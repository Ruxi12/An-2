import copy
import cv2
import numpy as np
import os
from PIL import Image
from sklearn.preprocessing import MinMaxScaler, normalize

from sklearn.svm import SVC, LinearSVC

test_labels = np.loadtxt('unibuc-brain-ad/data/sample_submission.txt', delimiter=',', dtype=str, skiprows=1)
train_labels = np.loadtxt('unibuc-brain-ad/data/train_labels.txt', delimiter=',', dtype=str, skiprows=1)
validation_labels = np.loadtxt('unibuc-brain-ad/data/validation_labels.txt',delimiter=',', dtype=str, skiprows=1)

def add_noise(image):
    mean = 0
    std_dev = 10
    noise = np.random.normal(mean, std_dev, image.shape)
    noisy_image = np.clip(image + noise, 0, 255).astype(np.uint8)
    return noisy_image

# Adjust brightness and contrast of image
def adjust_brightness_contrast(image, alpha=1.0, beta=0.0):
    adjusted_image = cv2.convertScaleAbs(image, alpha=alpha, beta=beta)
    return adjusted_image

#data augmentation paramaters
rotation_range = 10 # in degrees
horizontal_flip = True
vertical_flip = True
crop_size = 64

# parse train_data and labels for TRAIN--------------------------------------------------------------------------------------------------

data_dir = 'data/data/'
train_data = []
augmented_data = []
augmented_labels = []


# for time waiitng only:
range = 0

for i, elem in enumerate(train_labels):

    id, label = elem

    #read using openCV
    filename = f'{id}.png'
    img_path = os.path.join(data_dir, filename)
    img = cv2.imread(img_path, 0)


    if label == '1':
        img2 = copy.deepcopy(img)

        noisy_img = add_noise(img)
        bright_img = adjust_brightness_contrast(img, alpha=1.5, beta=50)

        # Rotate the image randomly within a certain range
        angle = np.random.uniform(-rotation_range, rotation_range)
        rows, cols = img2.shape
        M = cv2.getRotationMatrix2D((cols / 2, rows / 2), angle, 1)
        img2 = cv2.warpAffine(img2, M, (cols, rows))

        # Randomly flip the image horizontally and/or vertically
        if horizontal_flip and np.random.random() < 0.5:
            img2 = cv2.flip(img2, 1)
        if vertical_flip and np.random.random() < 0.5:
            img2 = cv2.flip(img2, 0)

        # normalize usinng l1
        img2 = normalize(img2, norm='l1', axis=1)
        noisy_img = normalize(img2, norm='l1', axis=1)
        bright_img = normalize(img2, norm='l1', axis=1)

        #add augmented data and label to collection
        augmented_data.append(img2)
        augmented_data.append(noisy_img)
        augmented_data.append(bright_img)
        augmented_labels.append(1)
        augmented_labels.append(1)
        augmented_labels.append(1)

    #normalize usinng MinMaxScaler
    scaler = MinMaxScaler()
    img = scaler.fit_transform(img)
    train_data.append(img)

#add augmented data at the end of training_data
for img in augmented_data:
    train_data.append(img)

# resize each picture as a 50176 array
train_data = np.array(train_data)
train_data = train_data.reshape(train_data.shape[0], 50176)


# parse train_data and labels for VALIDATION--------------------------------------------------------------------------------------------------
validation_data = []

for i, elem in enumerate(validation_labels):

    id, label = elem

    #read using openCV
    filename = f'{id}.png'
    img_path = os.path.join(data_dir, filename)
    img = cv2.imread(img_path, 0)

    #normalize usinng l1
    scaler = MinMaxScaler()
    img = scaler.fit_transform(img)
    validation_data.append(img)

# resize each picture as a 50176 array
validation_data = np.array(validation_data)
validation_data = validation_data.reshape(validation_data.shape[0], 50176)
# parse train_data for TEST--------------------------------------------------------------------------------------------------
test_data = []

for i, elem in enumerate(test_labels):

    id, label = elem

    #read using openCV
    filename = f'{id}.png'
    img_path = os.path.join(data_dir, filename)
    img = cv2.imread(img_path, 0)

    #normalize usinng l1
    scaler = MinMaxScaler()
    img = scaler.fit_transform(img)
    test_data.append(img)


# resize each picture as a 50176 array
test_data = np.array(test_data)
test_data = test_data.reshape(test_data.shape[0], 50176)

# parse labels and add augmented labels to training labels
train_labels_parse = []
for elem in train_labels:
    train_labels_parse.append(int(elem[1]))
for elem in augmented_labels:
    train_labels_parse.append(int(elem))

validation_labels_parse = []
for elem in validation_labels:
    validation_labels_parse.append(int(elem[1]))

# transform list to npArray
train_labels_parse = np.array(train_labels_parse)
validation_labels_parse = np.array(validation_labels_parse)

print('shape of train_data', train_data.shape)
print('shape of train_labels', len(train_labels_parse))
#CROSS-VALIDATION-------------------------------------------------------------------------------------------------------------
#

def get_interval(num_bins):
    bins = np.linspace(start=0, stop=255, num=num_bins) # imparte [0, 255] in numBins intervale de lungimi egale
    return bins


def values_to_bins(x, bins):
    new_x = np.zeros(x.shape)
    for i, elem in enumerate(x):
        new_x[i] = np.digitize(elem, bins) # returneaza indicele intervalului in care se potriveste fiecare element din x[i]
    return new_x - 1 # ca sa incepem de la 0

from sklearn.model_selection import KFold
from sklearn.metrics import accuracy_score
from sklearn.naive_bayes import MultinomialNB

best_k = -1
best_score = 0

bins = get_interval(4)

x_train = values_to_bins(train_data, bins)
x_test = values_to_bins(test_data, bins)

# Create a KFold object with 5 folds
kf = KFold(n_splits=5, shuffle=True, random_state=42)

# Initialize an empty list to store the accuracy scores
scores = []

# Loop over each fold of the data
for train_index, test_index in kf.split(train_data):
    # Split the data into training and testing sets for this fold
    X_train, X_test = train_data[train_index], train_data[test_index]
    y_train, y_test = train_labels_parse[train_index], train_labels_parse[test_index]

    # Train the model on the training data for this fold
    model = MultinomialNB()  # LinearSVC()
    model.fit(X_train, y_train)

    # Evaluate the model on the testing data for this fold
    y_pred = model.predict(X_test)
    score = accuracy_score(y_test, y_pred)
    scores.append(score)

#TESTING-------------------------------------------------------------------------------------------------------------

predictions = model.predict(test_data)
for i, elem in enumerate(predictions):
    test_labels[i][1] = elem

import pandas as pd
df = pd.DataFrame(test_labels, columns=['id', 'class'])

# export df to a CSV file

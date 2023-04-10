import numpy as np
from PIL import Image
from keras_preprocessing.image import img_to_array
import pandas as pd
from keras_preprocessing.image import ImageDataGenerator
from sklearn.naive_bayes import MultinomialNB

import glob
import cv2 as cv

def read_image(id):
    image = Image.open("unibuc-brain-ad/data/data/" + id + ".png")
    image = image.convert('L')
    return img_to_array(image)

# class CTDataset:
#     def __init__(self, data, labels):
#         self.data = data
#         self.labels = labels
#
#     def __len__(self):
#         return len(self.labels)
#
#     def __getitem__(self, idx):
#         return self.data[idx], self.labels[idx]
#
# class NearestNeighbor(object):
#     def __init__(self, train_images, train_labels):
#         self.train_images = train_images
#         self.train_labels = train_labels
#
#     def predict_cs (self, X):
#         num_test = X.shape[0]
#         # make sure that the output matches the input type
#         Ypred = np.zeros(num_test, dtype = self.train_labels.dtype)
#
#         # loop over all test rows
#         for i in range(num_test):
#             # find the nearest training iamge to the i'th test image
#             # using L1 distance ( sum of absolute value differences
#             distances = np.sum(np.abs(self.train_labels - X[i, :]), axis = 1)
#             # get the index with the smallest distance
#             min_index = np.argmin(distances)
#             # predict the label of the nearest example
#             Ypred[i] = self.train_labels[min_index]
#
#         return Ypred
#
#     def classify_image (self, test_image, num_neighbors = 3, metric = 'l1'):
#         if (metric == 'l2'):
#             distances = np.sqrt(np.sum((self.train_labels - test_image) ** 2, axis = 1))
#         else:
#             distances = np.sum(abs(self.train_labels - test_image), axis = 1)
#
#         sort_index = np.argsort(distances)
#         sort_index = sort_index[:num_neighbors]
#         nearest_labels = self.train_labels[sort_index]
#         histc = np.bincount(nearest_labels)
#
#         return np.argmax(histc)
#
#     def classify_images(self, test_images, num_neighbors = 3, metric = 'l2'):
#         num_test_images = test_images.shape[0]
#         predicted_labels = np.zeros((num_test_images))
#
#         for i in range (num_test_images):
#             predicted_labels[i] = self.classify_image(test_images[i], num_neighbors=num_neighbors, metric = metric)
#
#         return predicted_labels
#
#     def accuracy_score(self, predictions):
#         return (self.train_labels == predictions).mean()



# citire labels
train_labels = pd.read_csv('unibuc-brain-ad/data/train_labels.txt', dtype = str)
val_labels = pd.read_csv('unibuc-brain-ad/data/validation_labels.txt', dtype = str)
sample_labels = pd.read_csv('unibuc-brain-ad/data/sample_submission.txt', dtype = str)

# parsare date citite si transformarea lor in numpy.arrays
train_data = [read_image(row['id']) for _, row in train_labels.iterrows()]
train_data = np.array(train_data)
val_data = [read_image(row['id']) for _, row in val_labels.iterrows()]
val_data = np.array(val_data)
test_data = [read_image(row['id']) for _, row in sample_labels.iterrows()]
test_data = np.array(test_data)


train_data = train_data.reshape(-1, 224, 224, 1) / 255.0
val_data = val_data.reshape(-1, 224, 224, 1) / 255.0
test_data =test_data.reshape(-1, 224, 224, 1) / 255.0

datagen = ImageDataGenerator(
    rotation_range=10,
    width_shift_range=0.1,
    height_shift_range=0.1,
    horizontal_flip=True
)
datagen.fit(train_data)

augmented_data_generator = datagen.flow(train_data, train_labels, batch_size=32)
print(val_data.shape, val_labels.shape )
print(val_labels)
print()
# Train a Naive Bayes classifier on your augmented data
classifier = MultinomialNB()
for x_batch, y_batch in augmented_data_generator:
    print(y_batch.shape)
    y_batch = np.argmax(y_batch, axis=1)
    x_batch = np.reshape(x_batch, (x_batch.shape[0], -1))  # flatten each image
    classifier.partial_fit(x_batch, y_batch, classes=np.unique(train_labels))
    if augmented_data_generator.batch_index == 10:
        break

# Evaluate the classifier on your validation data
val_data_gray = np.mean(val_data, axis=3)
val_data_flat = np.reshape(val_data_gray, (val_data_gray.shape[0], -1))

# Convert labels to 1D array
if len(val_labels.shape) > 1 and val_labels.shape[1] > 1:
    val_labels_flat = np.argmax(val_labels, axis=1)
else:
    val_labels_flat = val_labels.ravel()

val_accuracy = classifier.score(val_data_flat, val_labels_flat)
print('Validation accuracy:', val_accuracy)



# # Evaluate the classifier on your test data
# test_data_gray = np.mean(test_data, axis=3)
# test_data_flat = np.reshape(test_data_gray, (test_data_gray.shape[0], -1))
# test_accuracy = classifier.score(test_data_flat, test_labels)
# print('Test accuracy:', test_accuracy)

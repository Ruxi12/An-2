import numpy as np
import pdb
import matplotlib.pyplot as plt
from skimage import io
import sklearn.metrics as sm


class KnnClassifier:
    def __init__ (self, train_images, train_labels):
        self.train_images = train_images
        self.train_labels = train_labels

    def classify_image (self, test_image, num_neighbors = 3, metric = 'l1'):
        if (metric == 'l2'):
            distances = np.sqrt(np.sum((self.train_images - test_image) ** 2, axis = 1))
        elif metric == 'l1':
            distances = np.sum(abs(self.train_images - test_image), axis = 1)
        else:
            print ('Eroare! {} nu este definita'.format(metric))

        #obtinem in sort_index indicii care ar sorta array-ul de distances crescator (argsort)
        sort_index = np.argsort(distances)
        #luam primele num_neighbors valori ( in acest caz 3)
        sort_index = sort_index[:num_neighbors]
        # obtinem cei mai apropiati vecini - ne uitam in matricea de train_labels la randurile sort_index[0], sort_index[1] .. [2]
        nearest_labels = self.train_labels[sort_index]
        # le transformam in np.int64 pt ca nu poate sa faca cast automat ( le-am citit cu np.loadtext ca float-uri
        nearest_labels = nearest_labels.astype(np.int64)
        # numaram aparitiile fiecarui label - un fel de vector de frecventa
        histc = np.bincount(nearest_labels)

        return np.argmax(histc) #returnam indexul valorii maxime

    def classify_images (self, test_images, num_neighbors = 3, metric = 'l2'):
        num_test_images = test_images.shape[0]  # the number of images in the dataset
        # array of ints full of 0s, length = nr de imagini din dataset
        predicted_labels = np.zeros((num_test_images), np.int64)

        for i in range (num_test_images):
            if i % 50 == 0:    # am imaprtit in chunk-uri de cate 50 ca sa mi se afiseze pe ecran cat la suta au fost procesate
                print("Processing {}%...".format(i / num_test_images * 100))
            # pentru fiecare imagine in parte (un rand in matricea de test_images, se apeleaza metoda din clasa
            predicted_labels[i] = self.classify_image(test_images[i, :],
                                        num_neighbors=num_neighbors, metric = metric)

        return predicted_labels

# y_true =  valorile corecte din sample - o sa primeasca ca si argument test_labels
# y_pred = rezultatul predictiilor
def accuracy_score (y_true, y_pred):
    # daca sunt egale -> TRUE ( 1)
    # li se face media
    return (y_true == y_pred).mean()
    # va intoarce o valoare intre 0( complete missclassification) si 1 (perfect)

def confusion_matrix_v2 (y_true, y_pred):
    num_classes = max(y_true.max(), y_pred.max()) + 1
    conf_matrix = np.zeros((num_classes, num_classes))

    for i in range(len(y_true)):
        conf_matrix[int(y_true[i]), int(y_pred[i])] += 1
    return conf_matrix

train_images = np.loadtxt('data/train_images.txt')
train_labels = np.loadtxt('data/train_labels.txt', 'float')

#print (train_labels)

# for linie in train_images:
#     for elem in linie:
#         print(elem, end=" ")
#     print()

image = train_images[0, :]  # prima imagine
# print(image)
image = np.reshape(image, (28, 28))  # o transformam in matrice 28X28
# use io -> scikit-image for imagine processing
# astype(np.uint8) = used to convert the image data to an 8-bit unsigned format
# (many libraries require this format)
io.imshow((image).astype(np.uint8))
io.show()

"""EXERCITIile 1, 2,  3"""

# constructor
classifier = KnnClassifier(train_images, train_labels)

# citire date de test
test_images = np.loadtxt('data/test_images.txt')
test_labels = np.loadtxt('data/test_labels.txt', 'float')

predicted_labels = classifier.classify_images(test_images, 3, metric = 'l2')

accuracy = accuracy_score(test_labels, predicted_labels)

print("\nAcuratetea obtinuta cu distanta l2 este {}%!".format(accuracy*100))

"""exercitiul 4"""

# formez array-ul de vecini  [ 1, 3, 5, 7, 9]
max_num_neighbors = 10
num_neighbors = [i for i in range (1, max_num_neighbors, 2)]

accuracy = np.zeros((len(num_neighbors)))  # nparray cu 5 0s

for n in range (len(num_neighbors)):
    predicted_labels = classifier.classify_images(test_images, num_neighbors = num_neighbors[n], metric = 'l2')
    print()
    accuracy[n] = accuracy_score(test_labels, predicted_labels)

np.savetxt('acuratete_l2.txt', accuracy)

# ploteaza punctele in grafic
plt.plot(num_neighbors, accuracy)

# se adauga etichete pentru fiecare axa
plt.xlabel('numarul vecinilor')
plt.ylabel('acuratete')

#afiseaza figura
plt.show()

#b -  verificam acuratetea pt l1 si dupa facem grafic
accuracy = np.zeros(len(num_neighbors))

for n in range(len(num_neighbors)):
    predicted_labels = classifier.classify_images(test_images, num_neighbors = num_neighbors[n], metric = 'l1')
    accuracy[n] = accuracy_score(test_labels, predicted_labels)

acuratete_l2 = np.loadtxt('acuratete_l2.txt')
np.savetxt('acuratete_l1.txt', accuracy)

plt.plot(num_neighbors, accuracy)
plt.plot(num_neighbors, acuratete_l2)
plt.gca().legend(('metoda L1', 'metoda L2'))

#adaugare etichete
plt.xlabel('numarul vecinilor')
plt.ylabel('acuratete')


# afisare
plt.show()


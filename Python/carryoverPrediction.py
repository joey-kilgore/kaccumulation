import tensorflow as tf
import matplotlib.pyplot as plt
import numpy as np
import random
from tqdm import tqdm
from numpy import genfromtxt

my_data = genfromtxt('./Python/all_carryover.csv', delimiter=',')
data_without_nan = my_data[1:,0:10]
x_data = data_without_nan[0:,[1,2,3,4,5,7,8,9]]

x_normed = (x_data - x_data.min(0)) / x_data.ptp(0)
print(x_normed)
print(x_normed.shape)

# xT = x_data.T
# x_tuples = list(zip(xT[0],xT[1],xT[2],xT[3],xT[4],xT[5],xT[6],xT[7],xT[8]))
# x_data_tuples = np.array(x_tuples)
y_data = data_without_nan[0:,-4]/1000

def build_fc_model():
    fc_model = tf.keras.Sequential([
        tf.keras.layers.Input(8),
        tf.keras.layers.Dense(128, activation=tf.nn.relu),
        tf.keras.layers.Dropout(0.6),
        tf.keras.layers.Dense(128, activation=tf.nn.relu),
        tf.keras.layers.Dropout(0.6),
        tf.keras.layers.Dense(1,activation=tf.nn.relu)
    ])
    return fc_model

model = build_fc_model()
model.compile(optimizer='adam',
              loss='mean_squared_error',
              metrics=['accuracy'])

history = model.fit(x_normed,y_data, validation_data=(x_normed,y_data), epochs=100, verbose=1, batch_size=2)

test_loss, test_acc = model.evaluate(x_normed,y_data)
print('Test accuracy:', test_acc)

print(model.predict(x_normed)*1000)

plt.title('Loss / Mean Squared Error')
plt.plot(history.history['loss'], label='train')
plt.plot(history.history['val_loss'], label='test')
plt.legend()
plt.show()
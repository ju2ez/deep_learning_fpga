#!/usr/bin/env python


"""Audio Augmentation
This script should makes use of the Audio Augmentation class.
It loads several audio_samples (wav format), runs augmentation functions on them and stores them in specified folders. 

The aim is to create more data for a Neural Network input.
"""

__author__ = "Julian Hatzky"
__copyright__ = "Copyright 2019, Cologne University of Applied Sciences Project"
__credits__ = ["Husein Zolkepli", "Tobias Krawutschke"]
__license__ = "MIT"
__version__ = "0.0.1"
__maintainer__ = "Julian Hatky"
__email__ = "julianhatzky@googlemail.com"
__status__ = "Research Project"
		





import librosa
import numpy as np
import matplotlib.pyplot as plt
from scipy.io.wavfile import read,write
import scipy.io.wavfile
from IPython.display import Audio
from AudioAugmentation import AudioAugmentation
import random
import os

path_sample_1="./audio_samples/sample1.wav"
path_sample_2="./audio_samples/sample2.wav"
path_sample_3="./audio_samples/sample3.wav"

path_samples=[path_sample_1,path_sample_2,path_sample_3]
audio_augmentation = AudioAugmentation()
augmented_audio_samples_dir="augmented_audio_samples"

function = ['change_audio_pitch_and_speed', 'change_audio_speed', 'audio_value_augmentation', 'add_random_distributed_noise', 'random_shifting', 'add_hpss', 'shift_silent_right','stretching']


def sample_to_file(data,filename,rate):
    scipy.io.wavfile.write(filename, rate, data)


def create_sample_dir(sample_dir):
    sample_dir = augmented_audio_samples_dir+'/'+sample_dir

    try:
            os.mkdir(sample_dir)
    except FileExistsError:
            pass




def create_samples(augmentation_function, amount_of_samples=100):
#create audio samples for each augmentation function out of the 3 given audio samples
    sample_dir=augmentation_function
    for k in range (amount_of_samples):
            file_dir= augmented_audio_samples_dir+"/"+sample_dir+"/sample_"+str(k)+"_noise.wav"
            random_number=random.randint(0,2)
            sample_rate,samples = scipy.io.wavfile.read(path_samples[random_number])
            augmented_sample_rate, augmented_samples=audio_augmentation.change_audio_speed(sample_rate, samples)
            sample_to_file(samples,file_dir, augmented_sample_rate)



def main():
        
                
    for i in range(len(function)):
            create_sample_dir(function[i])
            create_samples(function[i], 100)         
        
        
        

if __name__ == '__main__' : 
        main()


if __name__ == '__init__' : 
    try:
            os.mkdir(augmented_audio_samples_dir)
    except FileExistsError:
            pass

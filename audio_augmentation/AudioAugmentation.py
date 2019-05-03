#!/usr/bin/env python

"""Audio Augmentation
This class should ease the creation of new Audio Data by augmenting the Audio Data which is already given.
The audio data should be in .wav format.
The class AudioAugmentation provides several different functions that can modify / augment the audio data in certain ways.
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
from scipy.io.wavfile import read
import scipy.io.wavfile
from IPython.display import Audio



class AudioAugmentation:
    
    
    def change_audio_pitch_and_speed(sample_rate, samples):
        y_pitch_speed = samples.copy()
        # you can change low and high here
        length_change = np.random.uniform(low=0.9, high = 1)
        speed_fac = 1.0  / length_change
        print("resample length_change = ",length_change)
        tmp = np.interp(np.arange(0,len(y_pitch_speed),speed_fac),np.arange(0,len(y_pitch_speed)),y_pitch_speed)
        minlen = min(y_pitch_speed.shape[0], tmp.shape[0])
        y_pitch_speed *= 0
        y_pitch_speed[0:minlen] = tmp[0:minlen]
        Audio(y_pitch_speed, rate=sample_rate)
        return sample_rate, y_pitch_speed
    
    
    def change_audio_speed(self,sample_rate, samples):
        y_speed = samples.copy()
        speed_change = np.random.uniform(low=0.9,high=1.1)
        tmp = librosa.effects.time_stretch(y_speed.astype('float64'), speed_change)
        minlen = min(y_speed.shape[0], tmp.shape[0])
        y_speed *= 0 
        y_speed[0:minlen] = tmp[0:minlen]
        Audio(y_speed, rate=sample_rate)
        return sample_rate, y_speed
        
        
    def audio_value_augmentation(sample_rate, samples):
        y_aug = samples.copy()
        dyn_change = np.random.uniform(low=1.5,high=3)
        print("dyn_change = ",dyn_change)
        y_aug = y_aug * dyn_change
        print(y_aug[:50])
        print(samples[:50])
        Audio(y_aug, rate=sample_rate)
        return sample_rate, y_aug
        
    def add_random_distributed_noise(sample_rate, samples):
        y_noise = samples.copy()
        # you can take any distribution from https://docs.scipy.org/doc/numpy-1.13.0/reference/routines.random.html
        noise_amp = 0.005*np.random.uniform()*np.amax(y_noise)
        y_noise = y_noise.astype('float64') + noise_amp * np.random.normal(size=y_noise.shape[0])
        Audio(y_noise, rate=sample_rate)
        return sample_rate, y_noise
        

    def random_shifting(sample_rate, samples):
        y_shift = samples.copy()
        timeshift_fac = 0.2 *2*(np.random.uniform()-0.5)  # up to 20% of length
        print("timeshift_fac = ",timeshift_fac)
        start = int(y_shift.shape[0] * timeshift_fac)
        print(start)
        if (start > 0):
            y_shift = np.pad(y_shift,(start,0),mode='constant')[0:y_shift.shape[0]]
        else:
            y_shift = np.pad(y_shift,(0,-start),mode='constant')[0:y_shift.shape[0]]
        Audio(y_shift, rate=sample_rate)
        return sample_rate, y_shift

    def add_hpss(sample_rate, samples):
        y_hpss = librosa.effects.hpss(samples.astype('float64'))
        print(y_hpss[1][:10])
        print(samples[:10])
        Audio(y_hpss[1], rate=sample_rate)
        return sample_rate, y_hpss
                        

    def shift_silent_right(sample_rate, samples):
        samples[(samples > 200) | (samples < -200)]
        sampling=samples[(samples > 200) | (samples < -200)]
        shifted_silent =sampling.tolist()+np.zeros((samples.shape[0]-sampling.shape[0])).tolist()
        Audio(shifted_silent, rate=sample_rate)
        return sample_rate, shifted_silent

    def stretching(sample_rate, samples):
        input_length = len(samples)
        streching = samples.copy()
        streching = librosa.effects.time_stretch(streching.astype('float'), 1.1)
        if len(streching) > input_length:
            streching = streching[:input_length]
        else:
            streching = np.pad(streching, (0, max(0, input_length - len(streching))), "constant")
        Audio(streching, rate=sample_rate)
        return sample_rate, streching


    def plot_time_series(data):
        fig = plt.figure(figsize=(14, 8))
        plt.title('Raw wave ')
        plt.ylabel('Amplitude')
        plt.plot(np.linspace(0, 1, len(data)), data)
        plt.show()
        
        
        
        
        

import os
import librosa
import librosa.display
import matplotlib.pyplot as plt
import numpy as np

def explore_audio(file_path):
    print(f"Loading audio file: {file_path}")
    
    # Load the audio file
    # sr=None preserves the original sampling rate
    y, sr = librosa.load(file_path, sr=None)
    
    # Calculate duration
    duration = librosa.get_duration(y=y, sr=sr)
    
    print(f"Sample Rate (sr): {sr} Hz")
    print(f"Total Samples: {len(y)}")
    print(f"Duration: {duration:.2f} seconds")
    
    # Create a plot with two subplots: Waveform and Spectrogram
    plt.figure(figsize=(12, 8))
    
    # 1. Waveform Plot
    plt.subplot(2, 1, 1)
    librosa.display.waveshow(y, sr=sr, alpha=0.6)
    plt.title(f'Waveform: {os.path.basename(file_path)}')
    plt.xlabel('Time (s)')
    plt.ylabel('Amplitude')
    
    # 2. Spectrogram Plot (Mel Spectrogram)
    plt.subplot(2, 1, 2)
    # Compute the Mel spectrogram
    S = librosa.feature.melspectrogram(y=y, sr=sr, n_mels=128)
    # Convert to log scale (dB)
    S_dB = librosa.power_to_db(S, ref=np.max)
    librosa.display.specshow(S_dB, sr=sr, x_axis='time', y_axis='mel')
    plt.colorbar(format='%+2.0f dB')
    plt.title('Mel Spectrogram')
    
    plt.tight_layout()
    
    # Save the plot
    output_filename = 'audio_visualization.png'
    plt.savefig(output_filename)
    print(f"Visualization saved as '{output_filename}' in your current directory.")
    
    # If running in VS Code with interactive window or terminal that supports it, 
    # plt.show() will display it. We'll rely on saving the file for now.
    # plt.show()

if __name__ == "__main__":
    # Test with the first blues song
    sample_file = os.path.join("..", "genres", "blues", "blues.00000.au")
    
    # Since we are probably running from the project root or src folder, 
    # let's find the absolute or relative path that works.
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    file_to_load = os.path.join(project_root, "genres", "blues", "blues.00000.au")
    
    if os.path.exists(file_to_load):
        explore_audio(file_to_load)
    else:
        print(f"Could not find the file at {file_to_load}. Please check the path.")

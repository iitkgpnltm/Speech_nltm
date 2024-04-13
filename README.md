NLTM Speech Technologies in Indian Languages
Prosody Modelling for ASR (IIT Kharagpur)

As part of this project, we developed prosodic transcription tool which can extract (i) pitch contour transcription at segmental level (60 ms) and syllable levels and pause patterns in terms of 4 break indices.

The executable demo version of the tool is made available at  http://speech.iitkgp.ac.in/nltm/

1. Pitch contour transcription at segmental level: 
All the codes related to generation of pitch contour transcription at segmental level are available in “pitch_trans” folder. The main file responsible for  generation of pitch contour transcription at segmental level is “prosodytrans.m”. While its execution, it calls several other matlab codes (.m files). Within pitch_trans folder there are 2 folders named “input_wave” (input_wave folder contains speech signal (in wav format) whose pitch transcription to be extracted. ) and “output_file” (output_file contains 3 files: (i) Pitch_lable.text (which stores pair of pitch transcription labels (L, VL, H, VH, NP) associated to each of the segment of 60 ms) and  (ii) inputspeech.jpg and PitchTranscription.jpg  files refer to image files of input speech signal and pitch transcription of the input speech signal)

2. Pitch contour transcription at syllable level:
All the codes related to generation of pitch contour transcription at syllable level are available in “pitch_vop” folder. The main file responsible for  generation of pitch contour transcription at syllable level is “mergedlabel.m”. While its execution, it calls several other matlab codes (.m files). Within “pitch_vop” folder there are 2 folders named “input_wave” (input_wave folder contains speech signal (in wav format) whose pitch transcription to be extracted. ) and “output_file” (output_file contains 3 files: (i) Pitch_lable.text (which stores pair of pitch transcription labels (L, VL, H, VH, NP) associated to each of the segment of 60 ms) and  (ii) inputspeech.jpg and PitchTranscription.jpg  files refer to image files of input speech signal and pitch transcription of the input speech signal)

3. Transcription of pause patterns:
All the codes related to generation of pause pattern transcription with 4 break indices are available in “break_indices” folder. The main file responsible for generation of pause pattern transcription is “break_indices.m”. Within “break_indices” folder there are 2 folders named “input_wave” (input_wave folder contains speech signal (in wav format) whose pause pattern transcription to be extracted.) and “output_file” (output_file contains 2 files: (i) break_trans.txt (which stores pair of time stamps indicating the pause segment and its  transcription labels (B1, B2, B3, B4)) and  (ii) inputspeech.jpg  file refers to image file of input speech signal, superimposed by the generated pause patterns and their transcription.)

4. Demo of prosodic transcription tool: http://speech.iitkgp.ac.in/nltm/

# Ecological Momentary Assessment Demo
[Requirements](#Requirements) | [Current State](#CurrentState) | [To do](#Todo) | [Finished](#Finished)


## Requirements

* Get timestamped RR intervals in millisecond accuracy
* Get real-time RR intervals relating to the tasks

## CurrentState

* Finished the front-end of Questionnaire data collection (choice questions and scale questions)
<p align="center">
  <img src="resources/QuestionExample.JPG" height="50%" width="50%"/>
</p>

* Can read heart rate data from Apple Watch

* Can get image samples from camera in milliseconds accuracy, and show data in real-time
<p align="center">
  <img src="resources/HRView.gif" height="25%" width="25%"/>
  <img src="resources/chartView_realtime.gif" height="25%" width="25%"/>
</p>


## Todo

* Read references and process sample images
  * How to process sample images?
  * Detect spikes to calculate HR and HRV
* Build back-end platform to store data
* User info input
* Improve User Interface
  * Images need to be replaced
  * Add Back button
  * Label layout
  
  
## Finished

* Update real-time waveform

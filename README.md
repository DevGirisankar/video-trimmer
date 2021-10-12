# video-trimmer

This project demonstrates how to trim a video using ```AVAssetExportSession```

Project includes functionalities like 

- [x] Video preview. 
- [x] Select video from photo library or record a new one (using ```PHPickerViewController```  for new iOS versions and ```UIImagePickerController``` for old iOS versions)
- [x] Trim video and save video to Photos Library
- [x] Now the maximum time of video is limited to 2.5 minutes, can change it using ```trimmerView.maxDuration = 200``` 

Thanks to ```PryntTrimmerView``` for trim view

### Screenshot
![IMG_0017](https://user-images.githubusercontent.com/44155211/136952538-8cc8591f-0c45-4b1b-be9f-1d978fb79458.PNG)

### Note : 
- Icons are system icons so they won't be available in lower iOS versions.
- Not tested in lower iOS versions. (tested above iOS 14\*)

# Community Detection in Medical Image Datasets: Using Wavelets and Spectral Methods

This paper was presented the 3rd Conference on Medical Imaging and Computer-Aided Diagnosis in 2022 and published in the Springer's Lecture Notes in Electrical Engineering. Here is the preprint: https://arxiv.org/pdf/2112.12021.pdf

The proposed method uses wavelets to extract features from images and then performs spectral analysis on the wavelet features to idenify groups of similar images in the datasets. Algorithm provided in this repository is written in Matlab. I plan to provide a Python version in the near future. Please feel free to reach out if you have any questions.

You may find this other repository relevant: https://github.com/roozbeh-yz/similarities

In the experiments, three medical image datasets are used. First dataset contains a mixture of chest X-ray and CT-scan images of patients diagnosed with COVID-19. Dataset is publicly available at https://github.com/ieee8023/covid-chestxray-dataset. Second dataset is the histological images of colorectal cancer (CRC), publicly available at https://zenodo.org/record/1214456 and contains labeled images corresponding to 9 different types of colon tissues. Third dataset is a SARS-COV-2 CT-scan Dataset which is publicly available at https://github.com/Plamen-Eduardo/xDNN-SARS-CoV-2-CT-Scan.

% Define images to process
imageFileNames = {'checker1.jpg',...
    'checker2.jpg',...
    'checker3.jpg',...
    'checker4.jpg',...
    'checker5.jpg',...
    'checker6.jpg',...
    'checker7.jpg',...
    'checker8.jpg',...
    'checker9.jpg',...
    'checker10.jpg',...
    'checker11.jpg',...
    'checker12.jpg',...
    'checker13.jpg',...
    'checker14.jpg',...
    'checker15.jpg',...
    'checker16.jpg',...
    'checker17.jpg',...
    'checker18.jpg',...
    'checker19.jpg',...
    'checker20.jpg',...
    'checker21.jpg',...
    };

% Detect calibration pattern in images
detector = vision.calibration.monocular.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates for the planar pattern keypoints
squareSize = 1;  % in units of 'millimeters'
worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% Visualize pattern locations
h1=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'PatternCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);
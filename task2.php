<?php

$fileName = $_FILES['audioFile']['name'];
$fileTmpName = $_FILES['audioFile']['tmp_name'];
$fileSize = $_FILES['audioFile']['size'];
$fileError = $_FILES['audioFile']['error'];

$fileExt = explode(".", $fileName);
$fileActualExt = strtolower(end($fileExt));

$allowed = array('wav');

$error = "";
$flag = 0;


if (in_array($fileActualExt, $allowed)) {
    if ($fileError == 0) {
        if ($fileSize > 0 && $fileSize < 4000000) {
            $fileUniqId = uniqid('', true);
            //$fileNameNew = $fileUniqId . "." . $fileActualExt;
            $fileNameNew = 'input.wav';
            $fileDestination = '/var/www/html/nltm/pitch_vop/input_wave/' . $fileNameNew;
            move_uploaded_file($fileTmpName, $fileDestination);
            // exit();
            $pwd = getcwd();
            $prosody_dir = $pwd.'/pitch_vop';
            $wav_path = $fileDestination;
            $syllable_path = '/var/www/html/nltm/pitch_vop/output_file/syllable.txt';
			#$cmd = 'matlab -nosoftwareopengl -nosplash -nodesktop -sd ' . $prosody_dir . ' -r "prosodytrans('.'\''.$wav_path.'\''.','.'\''.$syllable_path.'\''.');exit" -logfile prosodylog.txt';
			# Modified on 25-7-2022 after merged label code incorporation
			$pre_cmd = 'rm /var/www/html/nltm/pitch_vop/output_file/*.*';
			$pre_out = exec($pre_cmd);
			$cmd = 'matlab -nosoftwareopengl -nosplash -nodesktop -sd ' . $prosody_dir . ' -r "label_vop('.'\''.$wav_path.'\''.');exit" -logfile prosodylog.txt';
			$dsample_out = exec($cmd);
        } else {
            $error = "*File should be between 4MB";
            $flag = 1;
        }
    } else {
        $error = "*There was an error uploading your file!";
        $flag = 1;
        // header("location:http://127.0.0.1/website/task1.php?fileName=" . $fileUniqId . "&fileExt=" . $fileActualExt . "&fileSize=" . $fileSize . "&error=" . $error);
        // exit();
    }
} else {
    $error = "*You can only upload files of wav type";
    $flag = 1;
    // header("location:http://127.0.0.1/website/task1.php?fileName=" . $fileUniqId . "&fileExt=" . $fileActualExt . "&fileSize=" . $fileSize . "&error=" . $error);
    // exit();
}



if ($flag) {
    $result = array("error" => $error);
    echo json_encode($result);
} else {
    $fileOpen = fopen("./pitch_vop/output_file/Pitch_label.txt", "r");
    $fileRead = fread($fileOpen, filesize("./pitch_vop/output_file/Pitch_label.txt"));
    $result = array(
        "img_o" =>
        "<div>(a) Speech signal.</div><img src = './pitch_vop/output_file/Input speech.jpg'>", "img_t" => "<div>(b) Prosody contour of the speech signal</div><img src='./pitch_vop/output_file/Pitch Transcription.jpg'>", "tsv" =>
        $fileRead,
        "error" => ""
    );

    echo json_encode($result);
};

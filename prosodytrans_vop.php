<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="style2.css">
</head>

<body>
    <header>
        <div class="logo"><a href="#"><img class="logo" alt="Logo" src="./img/kharagputr.png"></a></div>
        <div class="heading">Prosody Modelling for ASR and TTS</div>
        <div class="heading1">Speech Research Group, Indian Institute of Technology, Kharagpur.</div>
        <div class="heading1">Natural Language Translation Mission (NLTM) Project.</div>
    </header>
    <main>
        <form>
            <div class="container">
                <p>Select the speech file for transcribing the pitch contour at the syllable level.</p>
                <section class="input_con">
                    <input type="file" id="audioFile" name="audioFile">
                    <button class="button" name="submit" id="submit" type="button">Upload</button> &nbsp;<button class="button" name="btnback" id="btnback" onclick="location.href='http://speech.iitkgp.ac.in/nltm/'" type="button">Back</button>
                    <div id="error">
                    </div>
                </section>
                <div id="result">
                    <div class="img">
                        <div id="img_one"></div>
                        <div id="img_two"></div>

                    </div> 
                    <div>(c) Pitch transcribed labels (VL-Very low, L-Low, H-High, VH-Very high).</div>
                    <table class="table" id="myTable">
                        <thead id="thead">
                        </thead>
                        <tbody id="tbody">
                        </tbody>
                    </table>

                </div>
            </div>
        </form>
        <footer>
            <div class="disclaimer">Content owned and developed by speech research group, IITKGP. All rights reserved.</div>
        </footer>
    </main>
    <script src="task2_script.js"></script>
</body>

</html>









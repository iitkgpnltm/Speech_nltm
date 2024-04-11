// Submit Button
let subBtn = document.getElementById("submit");
subBtn.addEventListener("click", ajaxRequest);
// END

// Input file lable
let audioFile = document.getElementById("audioFile");

//
const resu = document.getElementById("result");

const image_o = document.getElementById("img_one");
const image_t = document.getElementById("img_two");

//Table
const tableHeading = document.getElementById("thead");
const tableData = document.getElementById("tbody");

const err = document.getElementById("error");

//Ajax request
function ajaxRequest() {
  if(audioFile.files.length == 0){
    err.innerHTML = "*Please upload a file";
    image_o.innerHTML = "";
    image_t.innerHTML = "";
    tableHeading.innerHTML = "";
    tableData.innerHTML = "";
    return;
  }
  var formData = new FormData();
  formData.append("audioFile", audioFile.files[0]);

  var xmlhttp = new XMLHttpRequest();

  //  What to do after the response
  xmlhttp.onload = function () {
    if (this.status == 200) {
      let response = JSON.parse(this.responseText);

      if (response["error"] != "") {
        console.log(response["error"]);
        err.innerHTML = response["error"];
        image_o.innerHTML = "";
        image_t.innerHTML = "";
        tableHeading.innerHTML = "";
          tableData.innerHTML = "";
        
      } else {
        err.innerHTML = response["error"];
        image_o.innerHTML = response["img_o"];
        image_t.innerHTML = response["img_t"];

        // Splitting data into array of lines.
        let data = response["tsv"].split("\n");
        // Splitting lines in array of words.
        //let line = data[0].split("	");

        // Inserting data into thead element.
        tableHeading.innerHTML = `<tr>
                                     <th>Start time (sec)</th>
                                     <th>End time (sec)</th>
                                     <th>Prosody Label</th>
                                     </tr>`;

        //  Inserting data into tbody element.
        let str = "";
        for (let i = 1; i < data.length-1; i++) {
          line = data[i].split("	");
          str += `<tr>
              <td>${line[0]}</td>
              <td>${line[1]}</td>
              <td>${line[2]}</td>
              </tr>`;
        }
        tableData.innerHTML = str;
      }
    }
  };

  xmlhttp.open("POST", "task2.php", true);

  xmlhttp.send(formData);
}

//End

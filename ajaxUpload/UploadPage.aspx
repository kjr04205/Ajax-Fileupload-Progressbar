<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UploadPage.aspx.cs" Inherits="DMSTransPC.SubForm.UploadPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>파일업로드</title>
    <script src="../Scripts/jquery-1.12.4.js"></script>
    <script src="../Scripts/jquery-ui.js"></script>
    <link rel="stylesheet" type="text/css" href="../CSS/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="../CSS/bootstrap-theme.css" />
    <link rel="stylesheet" type="text/css" href="../CSS/bootstrap.css" />
    
</head>
    
<body>
    
    <style>
        *{
           font-family:'sans-serif', Arial !important;
           margin:0;
           padding:0;
        }
        
        .container{
            padding:10px;
        }
        #cmbFileGroup{
            background-color:#e4e7ea; width:170px; height:24px; border-color:#bbb; border-radius:4px; font-size:12px; margin-right:10px;
        }
        #Label1{
            font-size:14px; margin-right:20px;
        }
       .input-file-button{
          background-color:#e4e7ea; width:90px; border-color:#bbb; border-radius:4px; font-size:12px; cursor: pointer;
          border:1px solid #bbb; padding:4px 10px; margin-right:10px;
       }
       #input-upload{
          background-color:#e4e7ea; width: 70px; border-color:#bbb; border-radius:4px; font-size:12px; cursor: pointer;
          border:1px solid #bbb; padding:4px 10px; font-weight:bold;
       }
       .progressbar {
          width:300px;
          height:21px;
          margin-left:120px;
          border:none;
        }
        .progressbarlabel {
          width:300px;
          height:21px;
          position:absolute;
          text-align:center;
        }
        .ui-widget-header{
            background:#c3e0ed;
        }
        #fileInfo{
            width:100%;
            height:auto;
            max-height:440px;
            max-width:538px;
            overflow:auto;
            border:1px solid #bbb;
            padding:20px 14px;
            margin-left:10px;
            list-style:none;
            font-size:13px;
            margin-top:12px;
        }
        .ui-widget-header
        {
            background: #cedc98;
            border: 1px solid #DDDDDD;
            color: #333333;
            font-weight: bold;
        }
        .progress-label
        {
            position: absolute;
            left: 50%;
            top: 13px;
            font-weight: bold;
            text-shadow: 1px 1px 0 #fff;
        }
        .red
        {
            color: red;
        }
        .MultiFile-list{
            margin-top:30px;
        }
        .MultiFile-label{
            display:block;
        }
        .MultiFile-label > span{
            color:#fff;
        }
        .MultiFile-label > span.MultiFile-title{
            color:#000;
        }
        #files{
            display:none;
        }
        .btn-primary{
            height:26px !important;
            padding-top:0 !important;
            padding-bottom:0 !important;
        }
        .fileListTxt{
            display:none;
            margin:0 20px;
            padding:15px;
            border:1px solid #bbb;
        }
        .progress_wrap{
            display:none;
        }
        .progress{
            margin: 10px 0 !important;
            border:1px solid #bbb;
        }
        .fileSize{
            margin:20px 10px 10px;
        }
        .fileSize .fileSizeTotal{
            font-size:13px;
            letter-spacing:-0.5px;
        }
    </style>
    <form id="form" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>    

        <div class="container">
            <div id="FileBrowse">
                <asp:Label ID="Label1" runat="server" Text="Server Upload folder path"></asp:Label>

                <asp:DropDownList ID="cmbFileGroup" runat="server" AutoPostBack="true" OnSelectedIndexChanged="cmbFileGroup_SelectedIndexChanged">
                </asp:DropDownList>
        
                <label class="input-file-button" for="files">Select Files</label>
                <button type="button" class="btn btn-primary" id="btnUpload">Upload</button>
                <button type="button" class="btn btn-primary" id="btnDelete">Clear List</button>
                <input type="file" id="files" class="selectFile" multiple="multiple" />
            
            </div>
            <div class="fileSize">
                <p class="fileSizeTotal"></p>
            </div>
            <div class="col-md-3 progress_wrap" style="padding:0 10px;">
                <div class="progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%">
                    </div> 
                </div>
            </div>
            
        </div>
    </form>
    <div class="fileListTxt">
                
    </div>
    <script>
        var fileList = [];
        var addFileTxt = "";
        var fileSizeValue = 0;
        var fileSizeValueTotal = 0;

        $('.selectFile').change(function () {
            var tmp = document.getElementById('files').files;

            if (fileList == undefined) {
                alert("선택한 파일이 없습니다. 파일을 선택해주세요.");
            } else {
                $('.progress_wrap').css('display', 'block');
                $('.fileListTxt').css('display', 'block');
                for (const file of tmp) {
                    fileSizeValue = parseFloat((file.size / (1024 * 1024)).toFixed(2));
                    fileSizeValueTotal = parseFloat((fileSizeValueTotal + fileSizeValue).toFixed(2));

                    console.log("fileSizeValue = " + fileSizeValue);
                    console.log("fileSizeValueTotal = " + fileSizeValueTotal);

                    if (fileSizeValueTotal > 1000) {
                        $('.fileSizeTotal').html("파일업로드 총 용량 : " + (fileSizeValueTotal / 1024).toFixed(2) + "GB");
                    } else {
                        $('.fileSizeTotal').html("파일업로드 총 용량 : " + fileSizeValueTotal.toFixed(2) + "MB");
                    }
                    
                    fileList.push(file);
                    
                    console.log(fileList.length);
                    addFileTxt = '<div class="addFileTxt_file">';
                    addFileTxt += '<p class="addFileTxt_file_name">';
                    addFileTxt += file.name;
                    addFileTxt += '</p>';
                    addFileTxt += '</div>';
                    $('.fileListTxt').append(addFileTxt);
                }
            }
        });

        $("#btnUpload").on('click', function () {
            if (fileList != "") {
                /*var j = 1;
                for (const file of fileList) {
                    addFileTxt = '<div class="progress">';
                    addFileTxt += '<div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">';
                    addFileTxt += '</div>';
                    addFileTxt += '</div>';
                    
                    $('.progress_wrap').append(addFileTxt);
                    $('.progress_wrap .progress:nth-child(' + j + ') .progress-bar').addClass('progress-bar' + j);
                    j++
                    console.log("현재 담겨있는 file = " + file.name);
                }*/
                var formData = new FormData();
                var fileUpload = $('#files').get(0);
                
                var folderName = $("#cmbFileGroup option:selected").text();
                var folderValue = $("#cmbFileGroup option:selected").val();
                formData.append("folderName", folderName);
                formData.append("folderValue", folderValue);
                
                for (var i = 0; i < fileList.length; i++) {
                    formData.append(fileList[i].name, fileList[i]);
                    
                }
                $.ajax({
                    url: "UploadHandler.ashx",
                    type: 'POST',
                    data: formData,
                    success: function (data) {
                        alert("파일업로드가 완료되었습니다.");
                        $('.progress-bar').text("업로드가 완료되었습니다.");
                    },
                    error: function (data) {
                        alert('error : ' + JSON.stringify(data));
                    },
                    cache: false,
                    contentType: false,
                    processData: false,
                    xhr: function () {
                        var xhr = new window.XMLHttpRequest();
                        xhr.upload.addEventListener("progress", function (evt) {
                            if (evt.lengthComputable) {
                                var percentComplete = Math.round((evt.loaded / evt.total) * 100);

                                $('.progress-bar').css('width', percentComplete + '%').attr('aria-valuenow', percentComplete);
                                $('.progress-bar').text(percentComplete + '%');
                                
                                if ($('.progress-bar').text() == '100%') {
                                    $('.progress-bar').text('로컬폴더 업로드 진행중...');
                                }
                                console.log(percentComplete);
                            }
                        }, false);
                        return xhr;
                    },
                });
            } else {
                alert("선택된 파일이 없습니다. 파일을 선택해주세요.");
            }
        });

        $("#btnDelete").on('click', function () {
            if (fileList != "") {
                fileList = [];
                if (fileList == "") {
                    console.log(fileList.length);
                    $('.addFileTxt_file').remove();
                    $('.progress').remove();
                    $('.progress_wrap').css('display', 'none');
                    $('.fileListTxt').css('display', 'none');
                    $('.progress-bar').css('width', '0%');
                    alert("파일리스트 초기화 완료");
                } else {
                    alert("파일리스트 초기화 오류 : 관리자에게 문의해주세요.");
                }
            } else {
                alert("파일이 선택되지 않았습니다.");
            }
        });
    </script>
</body>
</html>

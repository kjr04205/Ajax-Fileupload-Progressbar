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
        body{
            max-width:653px;
            min-width:652px;
            overflow:auto;
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
            margin:0 20px 20px;
            border:1px solid #bbb;
            max-width:630px;
        }
        .fileListTxt > ul{
            border-bottom:1px solid #bbb;
        }
        /*.fileListTxt li{
            list-style:none;
            display:inline-block;
            text-align:center;
        }
        .fileListTxt li.fileListTxt_Name{
            width:99%;
        }*/
        
        .fileListTxt .fileListTxt_wrap{
            padding:10px 15px 0;
        }
        .progress_wrap{
            display:none;
        }
        .progress{
            max-width:612px;
            margin: 10px 0 !important;
            border:1px solid #bbb;
            height:25px;
        }
        .fileSize{
            margin:20px 10px 10px;
        }
        .fileSize .fileSizeTotal{
            font-size:13px;
            letter-spacing:-0.5px;
        }
        .progress-bar{
            height:25px;
        }
        .addFileTxt_file{
            border-bottom:1px solid #bbb;
            margin-bottom:10px;
        }
        .addFileTxt_file_name{
            max-width:480px;
            text-overflow:ellipsis;
            letter-spacing:-0.5px;
            font-size:13px;
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
                <input type="file" id="files" class="selectFile" multiple="multiple" accept="video/*" />
            
            </div>
            <div class="fileSize">
                <p class="fileSizeTotal"></p>
                <p class="fileSizeProgress"></p>
            </div>
            <div class="col-md-3 progress_wrap" style="padding:0 10px;">
                <div class="progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%; padding-top:2px;">
                    </div> 
                </div>
            </div>
            
        </div>
    </form>
    <div class="fileListTxt">
        <div class="fileListTxt_wrap">

        </div>
    </div>
    <%-- 비동기 파일 업로드 컨트롤 --%>
    <script>
        var fileList = [];
        var addFileTxt = "";
        var addIcon = "";
        // iconNumber => 파일업로드 완료전 아이콘 컨트롤 넘버, checkNumber => 파일업로드 완료후 아이콘 컨트롤 넘버
        // 체크 icon color #2196f3
        var iconNumber = 1;
        var checkNumber = 1;

        var fileSizeValue = 0;
        var fileSizeValueTotal = 0;
        var index = 0;
        var length = 1;

        var folderName = "";
        var folderValue = "";
        const upload_target = document.getElementById('btnUpload');
        const delete_target = document.getElementById('btnDelete');
        const select_target = document.getElementById('files');

        var tmp = []; /* 선택된 파일 담길 리스트 선언 및 초기화 */
        var uploadFileName = "";

        upload_target.disabled = false;
        delete_target.disabled = false;

        $('.selectFile').change(function () {
            
            uploadFileName = document.getElementById('files').files[0].name;

            if (uploadFileName.substring(uploadFileName.lastIndexOf(".") + 1, uploadFileName.length).search("mp4") == -1) {
                alert("mp4 확장자의 파일만 업로드 가능합니다.");
                return false;
            }
            
            /* 선택된 파일 tmp에 담음 */
            tmp = document.getElementById('files').files;

            // fileList에 담아놨던 파일의 길이만큼 반복해서 fileList에 있는 파일이름과 방금 선택한 파일이름이 같은지 확인 후 false
            if (length < fileList.length) {
                for (var k = 0; k < fileList.length; k++) {
                    /* fileList 파일 이름 검사 */
                    if (fileList[k].name == uploadFileName) {
                        // 방금 선택된 파일 이름 초기화
                        uploadFileName = "";
                        alert("같은 파일이 파일리스트에 이미 존재합니다.");
                        return false;
                    }
                }
            }
            /* 웹서버 파일업로드 최대 2GB 제한 */
            var maxSize = 2147483648;
            
            var tmp_size = document.getElementById('files').files[0].size;
            
            if (fileList == undefined) {
                alert("선택한 파일이 없습니다. 파일을 선택해주세요.");
            } else if (tmp_size > maxSize) {
                alert("파일의 최대 크기는 2GB입니다.");
                return false;
            } else {

                $('.progress_wrap').css('display', 'block');
                $('.fileListTxt').css('display', 'block');
                $('.fileSizeTotal').css('display', 'block');

                /* IE 지원문제로 인해 javascript for of문 -> jQuery each문으로 변경 */
                $.each(tmp, function (idx, file) {
                    fileSizeValue = parseFloat((file.size / (1024 * 1024)).toFixed(2));
                    fileSizeValueTotal = parseFloat((fileSizeValueTotal + fileSizeValue).toFixed(2));

                    if (fileSizeValueTotal > 1000) {
                        $('.fileSizeTotal').html("파일업로드 총 용량 : " + (fileSizeValueTotal / 1024).toFixed(2) + "GB");
                    } else {
                        $('.fileSizeTotal').html("파일업로드 총 용량 : " + fileSizeValueTotal.toFixed(2) + "MB");
                    }
                    /* fileList에 tmp에서 받아온 file push */
                    fileList.push(file);

                    /* 파일 완료를 알릴 아이콘 추가 (완료전) */
                    addFileTxt = '<div class="addFileTxt_file">';
                    addFileTxt += '<p class="addFileTxt_file_name" style="display:inline-block;">';
                    addFileTxt += file.name;
                    addFileTxt += '</p>';
                    addFileTxt += '<img src="../image/circle.png" class="circle' + iconNumber + '"style="display:inline-block; width:17px; height:17px; margin-top:2px; float:right;">';
                    addFileTxt += '</img>';
                    addFileTxt += '<span class="addFileTxt_file_size" style="float:right; margin-right:10px; margin-top:3px; font-size:12px;">';

                    if (fileSizeValue > 1000) {
                        fileSizeValue = (fileSizeValue / 1024).toFixed(2);
                        addFileTxt += fileSizeValue + "GB";
                    } else {
                        addFileTxt += fileSizeValue + "MB";
                    }

                    addFileTxt += '</span>';
                    addFileTxt += '</div>';

                    $('.fileListTxt_wrap').append(addFileTxt);

                    iconNumber++;
                });
            }
        });

        $("#btnUpload").on('click', function () {
            if (fileList != "") {
                
                uploadAjax(fileList, index, function (err, res) {
                    if (err) { alert('error : ' + JSON.stringify(data)) }
                    else {
                        console.log("success 3");
                        $('.progress-bar').text("업로드가 완료되었습니다.");

                        select_target.disabled = false;
                        upload_target.disabled = false;
                        delete_target.disabled = false;
                    }
                });
                
            } else {
                alert("선택된 파일이 없습니다. 파일을 선택해주세요.");
                console.log('선택된 파일없음');
            }
        });

        /* 파일 업로드 진행 formData 생성, 실제 ajax 진행 */
        function uploadAjax(fileList, index, callback) {
            
            if (fileList.length <= index) {
                console.log("success 1");
                callback(null, 'success');
                return;
            }
            var formData = new FormData();

            formData.append(fileList[index].name, fileList[index]);

            folderName = $("#cmbFileGroup option:selected").text();
            folderValue = $("#cmbFileGroup option:selected").val();
            formData.append("folderName", folderName);
            formData.append("folderValue", folderValue);

            $.ajax({
                url: "UploadHandler.ashx",
                type: 'POST',
                data: formData,
                success: function (data) {
                    console.log("success 2");
                    $('.circle' + checkNumber).attr("src", "../image/check.png");
                    checkNumber++;
                    
                    uploadAjax(fileList, ++index, callback);
                },
                error: function (data) {
                    alert('비동기 처리 중 error : ' + JSON.stringify(data));
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

                            select_target.disabled = true;
                            upload_target.disabled = true;
                            delete_target.disabled = true;

                            if ($('.progress-bar').text() == '100%') {
                                $('.progress-bar').text('로컬폴더 업로드 진행중...');
                                console.log('로컬폴더 업로드 진행중...');
                            }
                            console.log(percentComplete);
                        }
                    }, false);

                    return xhr;
                },
            });
        }

        /* 파일리스트 초기화 */
        $("#btnDelete").on('click', function () {
            if (fileList != "") {
                fileList = [];
                if (fileList == "") {
                    checkNumber = 1;
                    iconNumber = 1;
                    fileSizeValue = 0;
                    fileSizeValueTotal = 0;
                    $('.fileSizeTotal').css('display','none');

                    $('.fileSizeProgress').attr('text', 'test');
                    $('.addFileTxt_file').remove();
                    $('.progress_wrap').css('display', 'none');
                    $('.fileListTxt').css('display', 'none');
                    $('.progress-bar').css('width', '0%');
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

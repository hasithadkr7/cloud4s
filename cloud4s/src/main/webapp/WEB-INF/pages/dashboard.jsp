<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="sec"
          uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="DashBoard for Cloud4s">
    <meta name="author" content="Sameera">

    <title>DashBoard - Cloud4s</title>

    <link href='<c:url value="/css/main.css" />' rel="stylesheet" type="text/css"/>
    <link href='<c:url value="/css/bootstrap.min.css" />' rel="stylesheet" type="text/css"/>
    <%--<link href='<c:url value="/css/bootstrap-theme.min.css" />' rel="stylesheet" type="text/css"/>--%>
    <%--<link href='<c:url value="/css/bootstrap.icon-large.min.css" />' rel="stylesheet" type="text/css"/>--%>
    <%--<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">--%>
    <link href='<c:url value="/fonts/css/font-awesome.min.css" />' rel="stylesheet" type="text/css"/>
    <link href='<c:url value="/css/dashboard.css" />' rel="stylesheet" type="text/css"/>

    <script src='<c:url value="/js/jquery-2.0.0.js" />' type="text/javascript"></script>
    <script src="js/main.js"></script>

    <!--AES sripts-->
    <script src="js/aes/jquery.js"></script>
    <script src="js/aes/aes.js"></script>
    <script src="js/aes/aes-ctr.js"></script>
    <script src="js/aes/aes-ctr-file.js"></script>
    <script src="js/aes/file-saver.js"></script>
    <script src="js/aes/mtl.js"></script>
    <script src="js/aes/prettify.js"></script>

    <!--RSA scripts-->
    <script src="js/rsa/aes.js"></script>
    <script src="js/rsa/rsa.js"></script>
    <script src="js/rsa/api.js"></script>
    <script src="js/rsa/cryptico.js"></script>
    <script src="js/rsa/cryptico.min.js"></script>
    <script src="js/rsa/hash.js"></script>
    <script src="js/rsa/jsbn.js"></script>
    <script src="js/rsa/random.js"></script>
    <script src="js/rsa/jsencrypt.js"></script>

    <sec:authorize access="hasRole('ROLE_USER')">
        <!-- For login user -->
        <c:url value="/j_spring_security_logout" var="logoutUrl" />
        <form action="${logoutUrl}" method="post" id="logoutForm">
            <input type="hidden" name="${_csrf.parameterName}"
                   value="${_csrf.token}" />
        </form>

        <c:url value="/upload" var="uploadUrl" />
        <form action="${uploadUrl}" method="get" id="uploadForm">
            <input id="fileName" name="fileName" type="hidden" value=""/>
        </form>

        <script>
            function formSubmit() {
                $('#logoutForm').submit();
            }
        </script>

    </sec:authorize>

    <script type="text/javascript">
        function harshikaAjax() {
            $.ajax({
                url : 'loadfiles.html',
                dataType : "json",
                cache : false ,
                contentType : 'application/json; charset=utf-8',
                type : 'GET',
                success : function(data) {
                var jsonLoadFiles=data.files;
                    console.log(jsonLoadFiles);
                    var tableData =" <thead><tr><th style='text-align: center'>"+ "#" +"</th><th style='text-align: left'>"+ "Name" +"</th><th style='text-align: left'>"+ "Kind" +"</th><th>"+ "  " +"</th></tr></thead>";
                    tableData += "<tbody>";
                    for(var i=0; i < jsonLoadFiles.length; i++){
                        var obj = jsonLoadFiles[i];
                        tableData += "<tr class='share-div'>";
                        tableData += "<td style='text-align:center'>" +(i+1)+"</td>";
                        tableData += "<td>"+obj["filename"]+"</td><td>"+obj["iconname"]+"</td><td style='text-align:center'>";
                       // Set download button at the end of the table raw.
                        var btn = " ";
                        btn += "<button class='share-button btn btn-primary btn-xs' style=";
                        btn += "'align:right'";
                        btn += "type='submit'";
                        btn += "id='"+"downloadButton"+i+" ' ";
                        btn += "onclick='"+"download("+"this.id"+")'";
                        btn += " value= '" +obj["filename"]+","+obj["path"]+"'>";
                        btn += "<i class='fa fa-download'></i>"
                        btn += "</button>";
                        btn += "&nbsp;&nbsp;";
                        btn += "<button class='share-button btn btn-primary btn-xs' style=";
                        btn += "'align:right'";
                        btn += "type='submit'";
                        btn += "id='"+"shareButton"+i+" ' ";
                        btn += "onclick='"+"share("+"this.id"+")'";
                        btn += " value= '" +obj["filename"]+","+obj["path"]+"'>";
                        btn += "<i class='fa fa-share'></i>"
                        btn += "</button>";
                        tableData += " "+btn+"</td>";
                        tableData += "</tr>";
                    }
                    tableData += "</tbody>";
                    $("table").html(tableData);
                }
            });
        }


        function download(id) {
            var values = (document.getElementById(id).value).split(",");;
            console.log(values);
//            alert(values);
            $.ajax({
                type : "Get",
                url : "download",
                data : "filename=" + values[0] + "&path=" + values[1],
                success : function(response) {
                    alert(values[0]+"successfully downloaded.");
                },
                error : function(e) {
                    alert('Error: ' + e);
                }
            });
        }

        function share(id) {
            var values = (document.getElementById(id).value).split(",");;
            console.log(values);
            alert(values);
        }

    </script>

</head>

<body onload="harshikaAjax()">
<%--Header--%>
<jsp:include page="header.jsp" />
<%--Body Content--%>
<div class="intro-header">

    <div class="container">
        <%--<a href="javascript:formSubmit()"><i class="fa fa-fw fa-power-off"></i> Log Out</a>--%>

        <!-- Sidebar Menu Items  -->
        <div class="collapse navbar-collapse navbar-ex1-collapse">
            <ul class="nav navbar-nav side-nav">
                <li>
                    <input name="password-file" id="password-encrpt" value="1234" type="text" hidden="hidden">
                        <span class="btn btn-default btn-file">
                            Upload
                            <input name="src-file" id="src-file" onchange="encryptFile(this.files[0])" type="file">
                        </span>

                </li>
                <li class="active">
                    <a href="dashboard.html"><i class="fa fa-fw fa-dashboard"></i> My Files</a>
                </li>
                <li>
                    <a href="dashboard.html"><i class="fa fa-fw fa-bar-chart-o"></i> Shared</a>
                </li>

            </ul>
        </div>

    </nav>

    <!--Content Area-->
    <div id="page-wrapper">
        <div class="container-fluid">
            <!-- Bread Crumb -->
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header"> My Files</h1>
                    <%--<ol class="breadcrumb">--%>
                        <%--&lt;%&ndash;<li class="active">&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<i class="fa fa-dashboard"></i> My Files&ndash;%&gt;--%>
                        <%--&lt;%&ndash;</li>&ndash;%&gt;--%>
                    <%--</ol>--%>
                </div>
            </div>
        </div>
    </div>
    <%--list display--%>
    <div class="table-responsive">
    <table id="table" name="table" class="table table-hover table-striped table-condensed">
        <%--<tr>--%>
            <%--<td>Name</td>--%>
            <%--<td>Icon</td>--%>
            <%--<td>Path</td>--%>
        <%--</tr>--%>
    </table>
    </div>
    <%--<div>--%>
        <%--<a href="#" class="btn btn-info btn-lg"><span class="fa fa-download"></span> Search</a>--%>
    <%--</div>--%>
    <%----%>
</div>

</div>
<%--Footer--%>
<jsp:include page="footer.jsp" />

</body>

</html>
<%--
  Created by IntelliJ IDEA.
  User: hp
  Date: 12/4/2014
  Time: 8:25 PM
  To change this template use File | Settings | File Templates.
--%>


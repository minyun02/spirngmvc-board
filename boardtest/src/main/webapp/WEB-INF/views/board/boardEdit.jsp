<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css" integrity="sha384-B0vP5xmATw1+K9KRQjQERJvTumQW0nPEzvF6L/Z6nronJ3oUOFUFpCjEUQouq2+l" crossorigin="anonymous">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.min.js" integrity="sha384-+YQ4JLhjyBLPDQt//I+STsc9iw4uQqACwlvpslubQzn4u2UU2UFM80nGisd026JF" crossorigin="anonymous"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
<script>
	$(function(){
		var subjectLength = "${vo.subject}";
		var useridLength = "${vo.userid}";
		var passwordLength = "${vo.password}";
		$("#subjectWord").text(subjectLength.length + "/" + 100);
		$("#idWord").text(useridLength.length + "/" + 5);
		$("#pwdWord").text(passwordLength.length + "/" + 10);
		
		//제목 글자수 보여주기-------------
		//글자 눌릴때 글자수보여주기
		subject.oninput = function(){
			var obj = $("#subject");
			var wordcheck = $("#subjectWord");
			checkblank(obj, '제목');
			subjectWordCount(obj, wordcheck);
		}
		//복붙했을때
// 		subject.oncut = subject.oncopy = subject.onpaste = function(){
// 			var obj = $("#subject");
// 			var wordcheck = $("#subjectWord");
// 			subjectWordCount(obj, wordcheck);
// 		}
		//작성자 글자수 보여주기---------------
		//눌릴때 보여주기
		userid.oninput = function(){
			var obj = $("#userid");
			var wordcheck = $("#idWord");
			checkblank(obj, '작성자')
			subjectWordCount(obj, wordcheck);
		}
		//복붙할때
// 		userid.oncut = userid.oncopy = userid.onpaste = function(){
// 			var obj = $("#userid");
// 			var wordcheck = $("#idWord");
// 			checkblank(obj, '작성자')
// 			subjectWordCount(obj, wordcheck);
// 		}
		//비밀번호 글자수 보여주기-------------
		//키보드 입력시
		password.oninput = function(e){
			var obj = $("#password");
			var wordcheck = $("#pwdWord");
			var pwdAlert = $("#pwdAlert");
// 			var myData = e.clipboardData.getData("text/plain").substr(0, obj.attr('maxlength'));
			
			checkblank(obj, '비밀번호')
			subjectWordCount(obj, wordcheck);
// 			pwdCheck(obj, pwdAlert, myData.length);
		}
		//복사 붙여넣기 할때
// 		password.oncut = password.oncopy = password.onpaste = function(e){
// 		password.onpaste = function(e){
// 			var obj = $("#password");
// 			var wordcheck = $("#pwdWord");
// 			var pwdAlert = $("#pwdAlert");
// 			var myData = e.clipboardData.getData("text/plain").substr(0, obj.attr('maxlength'));

// 			console.log(myData);
			
// 			checkblank(obj, '비밀번호')
// 			subjectWordCount(obj, wordcheck);
// 			pwdCheck(obj, pwdAlert, myData.length);
// 		}
		
		
		
		//글자수 보여주는 함수--------
		function subjectWordCount(obj, wordcheck){
			wordcheck.text(obj.val().length + "/" + obj.attr("maxlength"));
			if(obj.val().length >= obj.attr("maxlength")){
				setTimeout(function(){
					alert(obj.attr("maxlength")+"글자까지 입력 가능합니다.")
				}, 100);
				obj.val(obj.val().substr(0, obj.attr("maxlength")));
				wordcheck.text(obj.attr("maxlength") + "/" + obj.attr("maxlength"));
			}
			return obj.val().length;;
		}
		//공백 방지하는 함수------------
		function checkblank(obj, title){
			if(obj.val().trim() == "" && obj.val().length > 0){
				alert(title+"의 시작으로 공백이 들어갈 수 없습니다.");
				obj.val('');
			}
		}
		//비밀번호 유효성 검사 함수--------------
// 		function pwdCheck(obj, pwdAlert, clipboard){
		function pwdCheck(){
			console.log(clipboard)
			var pw = $("#password").val();
			var check = password.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
				
			if(pw.length == 0 || clipboard == 0){
// 				pwdAlert.text("");
// 				$("#pwdGo").css("display","none");
				return false;
			}else if(pw.search(/\s/) != -1){
// 				checkblank(obj, '비밀번호');
// 				$("#pwdGo").css("display","none");
				return false;
			}else if(pw.length < 6 || clipboard < 6){
// 				pwdAlert.text("6자리 이상입력해주세요.");
// 				alert("6자리 이상입력해주세요.");
// 				$("#pwdGo").css("display","none");
				return false;
			}else if(!check){
// 				pwdAlert.text("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				$("#pwdGo").css("display","none");
// 				if(pw.length >= 9 || clipboard >= 9){
// 					setTimeout(function(){
// 						alert("올바르지 않은 비밀번호입니다. 다시 확인해주세요");
// 					}, 100);
// 				}
				return false;
		    }else{
		    	$("#pwdGo").css("display",'inline-block')
		    	pwdAlert.text("");
		    }
			
		}
		
		//유효성 검사-----------------------
		$("#writeForm").on("submit", ()=>{
			//제목 공백 유효성
			if($("#subject").val().trim()==""){
				alert("제목을 입력하세요.")
				$("#subject").focus();
				return false;
			}
			//작성자 공백 유효성
			if($("#userid").val().trim()==""){
				alert("작성자를 입력하세요.")
				$("#userid").focus();
				return false;
			}
			//글 내용 유효성
			var content = $($("#content").summernote("code")).text();
			
			if(content.trim()==""){
				alert("내용을 입력해주세요.")	
				$('#content').summernote('focus');
				return false;
			}
			if($("#content").summernote('isEmpty')){
				alert("내용을 입력해주세요.")	
				$('#content').summernote('focus');
				return false;
			}
			//비밀번호 유효성 검사
			var check = password.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
			
			if($("#password").val().length < 6){
				alert("6자리 이상의 비밀번호를 입력하세요.")
				$("#password").focus();
				return false;
			}
			if($("#password").val().length >= 6 && !check){
				console.log(check)
				alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
				$("#password").focus();
				return false;
		    }
			if(pw.search(/\s/) != -1){
				alert("공백으로만 비밀번호를 설정할 수 없습니다. \n 영어, 숫자, 특수문자 조합 6~10자리 비밀번호를 설정해주세요.")
				$("#password").focus();
				return false;
			}
		});	
		
		//글 목록으로 돌아가기
		$("#list").click(function(){
			if(confirm("글 수정을 취소하고 목록으로 돌아가시겠습니까?")){
				location.href="/webapp/";
			}else{
				return false;
			}
		});
		
		//에디터 불러오기
		$("#content").summernote({
  			placeholder : '내용을 입력해주세요.',
  			height : 300,
  			width : 1000
  		});
		
		
// 		//글자수 제한
// 		//제목 글자수 네비게이터
// 		$("#subject").keyup(function(){
// 			$("#subjectWord").text($("#subject").val().length+"/"+$(this).attr("maxlength"));
// 			if($(this).val().length>$(this).attr("maxlength")){
// 				alert($(this).attr("maxlength")+"글자까지 입력 가능합니다.")
// 				$(this).val($(this).val().substr(0, $(this).attr("maxlength")));
// 				$("#subjectWord").text("100/100");
// 			}
// 		});
// 		$("#subject").click(function(){
// 			$("#subjectWord").text($("#subject").val().length+"/"+$(this).attr("maxlength"));
// 			if($(this).val().length>$(this).attr("maxlength")){
// 				alert($(this).attr("maxlength")+"글자까지 입력 가능합니다.")
// 				$(this).val($(this).val().substr(0, $(this).attr("maxlength")));
// 				$("#subjectWord").text("100/100");
// 			}
// 		});
		
// 		//작성자 글자수 네비게이터
// 		$("#userid").keyup(function(){
// 			$("#idCheck").text($(this).val().length+"/"+$(this).attr("maxlength"));
// 			if($(this).val().length>$(this).attr("maxlength")){
// 				alert("작성자는 " + $(this).attr("maxlength")+"글자까지 입력 가능합니다.")
// 				$(this).val($(this).val().substr(0, $(this).attr("maxlength")));
// 				$("#idCheck").text("5/5");
// 			}
// 		});
		
// 		//비밀번호 조합 안내
// 		$("#password").focus(function(){
// // 			$("#pwdCheck").text("숫자, 영문, 특수문자를 혼합하여 6~10자리로 입력해주세요.");
			
// 		});
		
// 		$("#password").focusout(function(){
// 			$("#pwdCheck").text("")
// 		});
		
// 		//공백 입력시 알림창
// 		//제목
// 		$(document).on("blur", "#subject", function(){
// 			if($(this).val().trim()==""){
// 				$("#blankCheck").css("display", "block");
// 				$(this).val("")
// 				$("#subject").focus();
// 			}else if($(this).val().trim()!=""){
// 				$("#blankCheck").css("display", "none");
// 			}
// 		});
// 		//작성자
// 		$(document).on('blur','#userid', function(){
// 			if($("#userid").val().trim()==""){
// 				$("#blankCheckUserid").css("display", "block");
// 				$(this).val("")
// 				$("#userid").focus();
// 			}else if($(this).val().trim()!=""){
// 				$("#blankCheckUserid").css("display", "none");
// 			}
// 		})
// 		//비밀번호
// 		$(document).on('blur','#password',function(){
// 			var pw = $("#password").val();
// 			var num = pw.search(/[0-9]/g);
// 			var eng = pw.search(/[a-z]/ig);
// 			var spe = pw.search(/[~!@#$%^&*()_+-|<>?:;`,{}\]\[/\'\"\\\']/gi);
			
// 			if(pw.length < 6 || pw.length > 10){
// 				$("#pwdCheck").text("6~10자리 이내로 입력해주세요.")
// 				$("#password").focus();
// 			}else if(pw.search(/\s/) != -1){
// 				$("#pwdCheck").text("비밀번호는 공백 없이 입력해주세요.");
// 				$("#password").focus();
// 			}else if(num <0 || eng < 0 || spe < 0){
// 				$("#pwdCheck").text("영문, 숫자, 특수문자를 혼합하여 입력해주세요.")
// 				$("#password").focus();
// 			}
// // 			else{
// // 				$("#pwdCheck").text("사용 가능한 비밀번호입니다.")
// // 			}
// 		})
		
// 		//유효성 검사
// 		$("#writeForm").on("submit", ()=>{
// 			//제목 공백 유효성
// 			if($("#subject").val().trim()==""){
// 				alert("제목을 입력하세요.")
// 				$("#subject").focus();
// 				return false;
// 			}
// 			//작성자 공백 유효성
// 			if($("#userid").val().trim()==""){
// 				alert("작성자를 입력하세요.")
// 				$("#userid").focus();
// 				return false;
// 			}
// 			//글 내용 유효성
// 			var content = $($("#content").summernote("code")).text();
			
// 			if(content.trim()=="" || $("#content").summernote('isEmpty')){
// 				alert("내용을 입력해주세요.")	
// 				$('#content').summernote('focus');
// 				return false;
// 			}
			
// 			//비밀번호 유효성
// 			var pw = $("#password").val();
// 			var num = pw.search(/[0-9]/g);
// 			var eng = pw.search(/[a-z]/ig);
// 			var spe = pw.search(/[~!@#$%^&*()_+-|<>?:;`,{}\]\[/\'\"\\\']/gi);
			
// 			if(pw.length < 6 || pw.length > 10){
// 				$("#pwdCheck").text("6~10자리 이내로 입력해주세요.")
// 				$("#password").focus();
// 				return false;
// 			}else if(pw.search(/\s/) != -1){
// 				$("#pwdCheck").text("비밀번호는 공백 없이 입력해주세요.");
// 				$("#password").focus();
// 				return false;
// 			}else if(num <0 || eng < 0 || spe < 0){
// 				$("#pwdCheck").text("영문, 숫자, 특수문자를 혼합하여 입력해주세요.")
// 				$("#password").focus();
// 				return false;
// 			}else{
// 				$("#pwdGo").css("display", 'block');
// 				return true;
// 			}
// 		});	
	});
</script>
<style>
	#subject{
		width: 950px;
	}
	#blankCheck, #blankCheckUserid{
		color: red;
		display: none;
	}
	#pwdAlert{
		color: red;
	}
	#pwdGo{
		color: green;
		display: none;
	}
</style>
</head>
<body>
	<div id="container">
		<h1>글수정</h1>
		<h3><a id="list" href="/webapp/">목록</a></h3>
		<form action="boardEditOk" method="post" id="writeForm" name="myform">
			<input type="hidden" name="boardNo" value="${vo.boardNo}">
			<ul>
				<li>제목 : <input id="subject" type="text" name="subject" maxlength="100" value="<c:out value="${vo.subject}"></c:out>" required >
							<span id="subjectWord"></span>
				</li>
				<li>작성자 : <input id="userid" type="text" name="userid" maxlength="5" required value="<c:out value="${vo.userid}"></c:out>">
							<span id="idWord"></span>
				</li>
				<li>비밀번호 : <input id="password" type="password" name="password" required maxlength="10" value="${vo.password}">
	<!-- 						oninput="this.value=this.value.replace(/[^0-9.]/g,'').replace(/(\..*)\./g, '$1');"> -->
				<span id="pwdWord"></span>
				<span id="pwdAlert"></span>
				<span id="pwdGo">사용가능한 비밀번호입니다.</span>
				</li>
				<li>글내용 : <br> 
					<textarea name="content" id="content" required><c:out value="${vo.content}"></c:out></textarea>
	<!-- 				<br><span id="contentCheck"></span> -->
				</li>
				<li>
					<input type="submit" value="수정">
	<!-- 				<input type="reset" value="reset"> -->
	<!-- 				<input id="cancelBtn" type="button" value="등록취소"> -->
				</li>
			</ul>
		</form>
	</div>
</body>
</html>
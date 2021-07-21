<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 내용보기</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css" integrity="sha384-B0vP5xmATw1+K9KRQjQERJvTumQW0nPEzvF6L/Z6nronJ3oUOFUFpCjEUQouq2+l" crossorigin="anonymous">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.min.js" integrity="sha384-+YQ4JLhjyBLPDQt//I+STsc9iw4uQqACwlvpslubQzn4u2UU2UFM80nGisd026JF" crossorigin="anonymous"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
<script>
	function boardEdit(){
		var locationUrl = "/webapp/boardEdit?boardNo=${vo.boardNo}";
		var data = "boardNo=${vo.boardNo}&password="
		var url = "/webapp/editCheck";
		getPassword(url, data, locationUrl)
	}
	
	function boardDelete(){
		var locationUrl = "/webapp/boardDelete?boardNo=${vo.boardNo}";
		var data = "boardNo=${vo.boardNo}&password="
		var url = "/webapp/editCheck";
		getPassword(url, data, locationUrl)
	}
	
	function getPassword(url, data, locationUrl){
		var pwd = prompt("비밀번호를 입력하세요");
		var params = data+pwd;
		if(pwd != null){
			checkPassword(url, params, locationUrl);
		}
	}
	
	function checkPassword(url, params, locationUrl){
		$.ajax({
			url : url,
			data : params,
			success : function(result){
				if(result==0){
					alert("비밀번호를 다시 확인해주세요.");		
					getPassword(locationUrl);
				}else if(result==1){
					location.href = locationUrl;
				}
			}, error : function(){
				
			}
		});
	}
	//댓글 삭제
	function commentDel(location){
		$.ajax({
			url : "/webapp/commentDel",
			data : location,
			success : function(result){
				if(result>0){//성공
					replyList();
					alert("댓글이 삭제되었습니다.");
				}else{
					alert("댓글 삭제에 실패했습니다. 다시 시도해주세요.")
				}
			}, error : function(result){
				console.log("댓글 삭제 실패..")
			}
		})
	}
	//댓글 수정창 보이기
	function commentEdit(obj){
		$(obj).parent().parent().css('display', 'none');
		$(obj).parent().parent().next().css('display', 'block');
		var pwdCount = $(obj).parent().parent().next().children().children().eq(3).children().val().length;
		var idcount = $(obj).parent().parent().next().children().children().eq(4).children().val().length;
		var contentcount = $(obj).parent().parent().next().children().children().eq(6).children().val().length;
		console.log(contentcount);
		$(obj).parent().parent().next().children().children().eq(3).children().next().text(pwdCount+"/10");
		$(obj).parent().parent().next().children().children().eq(4).children().next().text(idcount+"/5");
		$(obj).parent().parent().next().children().children().eq(6).children().next().text(contentcount+"/250");
	}
	//댓글 비번 확인=======================================
	function commentCheck(url, data, state, location, obj){
		var pwd = prompt("해당 댓글의 비밀번호를 입력하세요.")
		
		if(pwd != null){
			$.ajax({
				url : url,
				data : data+pwd,
				success : function(result){
// 					console.log("!!!!="+result)
					if(result>0){
						if(state == 'del'){
							commentDel(location);
						}else if(state == 'edit'){
							commentEdit(obj);
						}
					}else{
						alert("비밀번호를 다시 확인해주세요.")
						commentCheck(url, data, state, location, obj);
					}
				}, error : function(result){
					
				}
			})
		}
	}
	
	//validation check on submit
	function validationCheck(){
		var flag = true;
		//작성자 공백 유효성
		if($("#userid").val().trim()==""){
			alert("작성자를 입력하세요.")
			$("#userid").focus();
			flag = false;
		}
		//글 내용 유효성
		if($("#commentTextArea").val().trim()==""){
			alert("댓글 내용을 입력하세요.")
			$("#commentTextArea").focus();
			flag = false;
		}
		//비밀번호 유효성 검사
		var check = password.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
		var pw = $("#password").val();
		
		if($("#password").val().length < 6){
			alert("6자리 이상의 비밀번호를 입력하세요.")
			$("#password").focus();
			flag = false;
		}
		if($("#password").val().length >= 6 && !check){
// 			console.log(check)
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			$("#password").focus();
			flag = false;
	    }
		if(pw.search(/\s/) != -1){
			alert("공백으로만 비밀번호를 설정할 수 없습니다. \n 영어, 숫자, 특수문자 조합 6~10자리 비밀번호를 설정해주세요.")
			$("#password").focus();
			flag = false;
		}
		return flag;
	}
	
	//댓글 수정 유효성 검사
	function editValidationCheck(obj){
		var flag = true;
		var pwdField = $(obj).children().eq(3).children();
		var idField = $(obj).children().eq(4).children();
		var contentField = $(obj).children().eq(6).children();
		console.log(pwdField.val())
		//비밀번호 유효성 검사
		
		var check = pwdField.val().match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
		
		if(pwdField.val().length < 6){
			alert("6자리 이상의 비밀번호를 입력하세요.")
			pwdField.focus();
			flag = false;
		}
		if(pwdField.val().length >= 6 && !check){
// 			console.log(check)
			alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 6~10자리로 입력해주세요.");
			pwdField.focus();
			flag = false;
	    }
		if(pwdField.val().search(/\s/) != -1){
			alert("공백으로만 비밀번호를 설정할 수 없습니다. \n 영어, 숫자, 특수문자 조합 6~10자리 비밀번호를 설정해주세요.")
			pwdField.focus();
			flag = false;
		}
		//작성자 공백 유효성
		if(idField.val().trim()==""){
			alert("작성자를 입력하세요.")
			idField.focus();
			flag = false;
		}
		//글 내용 유효성
		if(contentField.val().trim()==""){
			alert("댓글 내용을 입력하세요.")
			contentField.focus();
			flag = false;
		}
		return flag;
	}
	
	//댓글 목록 불러오기
	function replyList(){
		$.ajax({
			url : "/webapp/commentList",
			data : "boardNo=${vo.boardNo}&currentPage=${cPage.currentPage}&totalPageNum=${cPage.totalPageNum}&lastPageCommentNum=${cPage.lastPageCommentNum}",
			success : function(result){
				console.log(result)
				var $result = $(result);
				var tag = "";
				var num = result.length;
				$result.each(function(idx, obj){
					tag += "<div>";
					tag += "<div class='commentNo'>"+num+"</div>";
					tag += "<div class='commentid'> 작성자 : <input class='commentuserid' type='text' value='"+obj.userid+"' readonly></div>";
					tag += "<div class='"+obj.commentNo+"'><button class='edit'>수정</button><button class='del'>삭제</button></div>";
					tag += "<div class='commentContent' escapeXml='true'>"+obj.content+"</div>";
					tag += "<div><input type='hidden' value='"+obj.password+"'/></div>";
					tag += "</div>"
					
					tag += "<div class='editDiv' style='display:none;'><form class='editForm' method='post' onsubmit='return false'>"
					tag += "<input type='hidden' name='boardNo' value='${vo.boardNo}'/>"
					tag += "<input type='hidden' name='commentNo' value='"+obj.commentNo+"'/>"
					tag += "<div class='commentNo'>"+num+"</div>";
					tag += "<div class='commentPwd commentid'> 비밀번호 : <input class='editPwd' type='password' name='password' value='"+obj.password+"' maxlength='10'><span id='editPwdcheck'>0/10</span></div>";
					tag += "<div class='commentid'> 작성자 : <input class='editid' type='text' name='userid' value='"+obj.userid+"' maxlength='5'><span id='editidcheck'>0/5</span></div>";
					tag += "<div class='"+obj.commentNo+"'><button class='finish'>완료</button><button class='cancel' type='button'>취소</button></div>";
					tag += "<div><textarea class='editContent' name='content' maxlength='250' wrap='hard'>"+obj.content+"</textarea><br><span class='editContentWord'>0/250</span></div>";
					tag += "</form></div>"
					num--;
				});
				
				$("#commentList").html(tag);
			}, error : function(){
				console.log("댓글 목록 로드 실패")
			}
		});
	}
	
	$(function(){
		replyList();
		
		//댓글---------------------------------------
		$(document).on('click', '#commentSubmit', function(){
			if(validationCheck()){
				//1. 댓글 쓰기============================
				var url = "/webapp/commentWriteOk";
				var params = $("#commentForm").serialize();
				
				$.ajax({
					url : url,
					data : params,
					success : function(){
						$("#commentTextArea").val("");
						$("#userid").val("");
						$("#password").val("");
						replyList();
					}, error : function(){
						console.log("...........")
					}
				})	
					
			}
			return false;
		});
		
		//2. 댓글 삭제하기
		$(document).on('click','.del', function(){
			if(confirm("해당 댓글을 삭제하시겠습니까?")){
				var commentNo = $(this).parent().attr("class");
				var url = "/webapp/commentCheck";
				var data = "commentNo="+commentNo+"&password=";
				var delUrl = "boardNo=${vo.boardNo}&commentNo="+commentNo;
				var obj = $(this);
				
				commentCheck(url, data, 'del', delUrl, obj);
			}
		});
		
		//3. 댓글 수정하기===============================================================수정
		$(document).on('click','.edit', function(){
			var commentNo = $(this).parent().attr("class");
			var url = "/webapp/commentCheck";
			var data = "commentNo="+commentNo+"&password=";
			var editUrl = "boardNo=${vo.boardNo}&commentNo="+commentNo;
			var obj = $(this);
			
			commentCheck(url, data, 'edit', editUrl, obj);
		});
		//3-1 댓글 수정 완료------
		$(document).on('submit', '.editForm', function(){
			var obj = $(this);
			if(confirm('댓글을 수정하시겠습니까?')){
				if(editValidationCheck(obj)){
					$.ajax({
						url : "/webapp/commentEdit",
						data : $(this).serialize(),
						success : function(result){
							replyList();
							console.log("댓글 수정 성공");
						}, error : function(){
							console.log("댓글 수정 실패...")
						}
					});
				}
			}
			return false;
		});
		//3-2 댓글 수정 취소===========================================================================================
		$(document).on('click','.cancel', function(){
			if(confirm("댓글 수정을 취소하시겠습니까??")){
				var oriUserid = $(this).parent().parent().parent().prev().children().eq(1).children().val();
				var oriPwd = $(this).parent().parent().parent().prev().children().eq(4).children().val();
				var oriContent = $(this).parent().parent().parent().prev().children().eq(3).text();
// 				console.log("oriUserid="+oriUserid)
// 				console.log("oriPwd="+oriPwd)
// 				console.log("oriContent="+oriContent)
				$(this).parent().prev().children().val(oriUserid); //작성자
				$(this).parent().prev().prev().children().val(oriPwd); //비번
				$(this).parent().next().children().val(oriContent); //내용
				$(this).parent().parent().parent().css('display', 'none');
				$(this).parent().parent().parent().prev().css('display', 'block');
			}
		});
		
		//댓글 수정시 작성자 글자수 보여주기
		$(document).on('input', '.editid', function(){
			var obj = $(this);
			var wordcheck = $(this).next();
			checkblank(obj, '댓글 작성자')
			subjectWordCount(obj, wordcheck);
		})
		//댓글 수정시 비밀번호 글자수 보여주기
		$(document).on('input', '.editPwd', function(){
			var obj = $(this);
			var wordcheck = $(this).next();
			checkblank(obj, '댓글 비밀번호')
			subjectWordCount(obj, wordcheck);
		});
		//댓글 수정시 본문 글자수 보여주기
		$(document).on('input', '.editContent', function(){
			var obj = $(this);
			var wordcheck = $(this).next().next();
			checkblank(obj, '댓글 본문')
			subjectWordCount(obj, wordcheck);
		});
		
		//작성자 글자수 보여주기---------------
		//눌릴때 보여주기
		userid.oninput = function(){
			var obj = $("#userid");
			var wordcheck = $("#useridWord");
			checkblank(obj, '작성자')
			subjectWordCount(obj, wordcheck);
		}
		//비밀번호 글자수 보여주기-------------
		//키보드 입력시
		password.oninput = function(e){
			var obj = $("#password");
			var wordcheck = $("#pwdWord");
			var pwdAlert = $("#pwdAlert");
			
			checkblank(obj, '비밀번호')
			subjectWordCount(obj, wordcheck);
		}
		
		//댓글 본문 글자수 보여주기-------------
		//키보드 입력시
		commentTextArea.oninput = function(){
			var obj = $("#commentTextArea");
			var wordcheck = $("#contentWord");
			checkblank(obj, '댓글 내용')
			subjectWordCount(obj, wordcheck);
		}
		
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
		
		
		//에디터 불러오기
		$("#content").summernote({
  			width : 1000,
  			height : 500,
  			toolbar : []
  		});
		$("#content").summernote('disable')
	})
</script>
<style type="text/css">
	ul, li{
		margin: 0;
		padding: 0;
		list-style: none;
	}
	#userid{
		margin-top: 15px;
	}
	#subjectView:focus {
	    outline: none !important;
	    border: none;
/* 	    box-shadow: 0 0 10px #719ECE; */
	}
	#commentTextArea{
		margin-top: 10px;
	}
	#commentSubmit{
		height: 126px;
	    position: relative;
	    top: -58px;
	}
	#commentList{
		width: 1000px;
	}
	.commentNo{
		border: 1px solid black;
	}
	.commentNo, .commentid{
		float: left;
		padding: 0 10px;
		height: 26px;
		line-height: 26px;
	}
	.commentid, .commentPwd{
		width: 305px;
		height: 40px;
	}
	.editContentWord{
		position: relative;
	    top: -55px;
	}
	.commentuserid{
		outline: none !important;
		border: none;
	}
	.editandDel{
	
	}
	.commentContent{	
		margin-bottom: 30px;
	}
	.commentContent, .editContent{
		border: 1px solid gray;
		width: 1000px;
		height: 150px;
		overflow: auto;
		padding: 10px;
		overflow-x: auto;
	}
	xmp{
		margin: 0;
	}
	.editid{
		margin-right: 10px;
	}
	#contentWord{
		position: relative;
		top: -55px;
		margin-bottom: 30px;
	}
	.on{
		font-weight: bold;
	}
	#pagingDiv{
		margin-bottom: 100px;
	}
</style>
</head>
<body>
	<div class="container">
		<h3><a href="/webapp/">목록</a></h3>
		<ul id="viewDetail">
			<li style="float:left; margin-right: 50px;">글번호 : <span>${vo.boardNo}</span></li>
			<li style="float:left; margin-right: 50px;">조회수 : <span>${vo.hit}</span></li>
			<li>작성자 : <span><c:out value="${vo.userid}"></c:out></span><li>
<%-- 			<li>파일 : ${vo.filename}</li> --%>
			<li>제목</li>	
			<li> <input id="subjectView" type="text" value="<c:out value="${vo.subject}"></c:out>" style="width: 1000px; height: 30px; line-height: 30px; border:1px solid; word-break:break-all;" readonly></li>
			<li>내용</li>
			<li>
			<textarea id="content" style="width: 1000px; height: 500px; border:1px solid; word-break:break-all; overflow: auto;"><c:out value="${vo.content}"></c:out></textarea>
<%-- 			<c:out value="${vo.content}"></c:out> --%>
			</li>
		</ul>
		<a href="javascript:boardEdit()">수정</a>
		<a href="javascript:boardDelete()">삭제</a>
		<a href="replyWrite?boardNo=${vo.boardNo}">답글</a><br>
		
		<form id="commentForm" method="post">
			<input type="hidden" name="boardNo" value="${vo.boardNo}">
			작성자 : <input id="userid" type="text" name="userid" maxlength="5">
			<span id="useridWord">0/5</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			비밀번호 : <input id="password" type="password" name="password" maxlength="10">
			<span id="pwdWord">0/10</span>
			<textarea id="commentTextArea" name="content" rows="6" cols="130" maxlength="250"></textarea>
			<input id="commentSubmit" type="submit" value="댓글작성">
			<p id="contentWord">0/250</p>			
		</form>
		<h3>댓글</h3>
		<div id="commentList"></div>
		<div style="width: 1000px;">
			<div id="pagingDiv">
			
				<c:if test="${cPage.totalCommentNum != null && cPage.totalCommentNum != ''}"><!-- 레코드가 없으면 첫페이지랑 < 안나와야한다 -->
	
					<c:if test="${cPage.currentPage!=1}"><!--1페이지가 아닐때만 첫페이지 버튼이 필요하다 -->
						<a href="/webapp/boardView?boardNo=${vo.boardNo}&currentPage=1">첫페이지</a>
					</c:if>
						
					<c:if test="${cPage.startPage!=1}"><!-- 시작페이지가 1이면 첫 페이지 세트이기때문에 페이지세트 이동 버튼이 필요없다 -->
						<a href="/webapp/boardView?boardNo=${vo.boardNo}&currentPage=${cPage.startPage-1}">&lt;</a>
					</c:if>
				</c:if>
			
				<c:forEach var="c" begin="${cPage.startPage}" end="${cPage.startPage + cPage.onePageNum-1}">
					<c:if test="${c <= cPage.totalPageNum}">
						<c:if test="${c==cPage.currentPage}">
							<a class="on" href="/webapp/boardView?boardNo=${vo.boardNo}&currentPage=${c}">${c}</a>
						</c:if>
						<c:if test="${c!=cPage.currentPage}">
							<a href="/webapp/boardView?boardNo=${vo.boardNo}&currentPage=${c}">${c}</a>
						</c:if>
					</c:if>
				</c:forEach>
				
				<c:if test="${cPage.totalCommentNum != null && cPage.totalCommentNum != ''}">
					<c:if test="${cPage.totalPageNum > cPage.endPage}"><!-- 총페이지수가 한 페이지세트 끝번호보다 크면  -->
						<a href="/webapp/boardView?boardNo=${vo.boardNo}&currentPage=${cPage.endPage+1}">&gt;</a>
					</c:if>
					
					<c:if test="${cPage.currentPage != cPage.totalPageNum}">
						<a href="/webapp/boardView?boardNo=${vo.boardNo}&currentPage=${cPage.totalPageNum}">마지막페이지</a>
					</c:if>
				</c:if>	
				
			</div>
		</div>
	</div>
</body>
</html>
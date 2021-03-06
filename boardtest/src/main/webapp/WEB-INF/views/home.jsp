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
<script src="https://cdn.ckeditor.com/4.16.0/standard/ckeditor.js"></script>
<script>
	var color = "";
	var num = 0;
	function setColor(){
		color = "#" + Math.round(Math.random() * 0xffffff).toString(16);
		return color;
	}
	function firstPage(){
// 		alert(color)
// 		alert(num)
		var url = "/webapp/?currnetPageNum=1<c:if test="${page.searchWord != null && page.searchWord != ''}">&searchKey=${page.searchKey}&searchWord=${page.searchWord}</c:if>&prev="+color+"&lastNum="+num;
		location.href = url;
	}
	$(function(){
		if(${page.totalRecord == 0}){
			setTimeout(function(){
				alert("검색 결과가 없습니다.");			
			}, 100);
		}
		
// 		<c:forEach items="${list}" var="item">
// 			color = "#" + Math.round(Math.random() * 0xffffff).toString(16);
// 			num = ${item.groupNo}
// // 			$('.${item.groupNo}').css('color', setColor());
// 			$('.${item.groupNo}').css('color', color);
// 			$('.${item.groupNo}').css('font-weight', 'bold');
// 		</c:forEach>
		
// 		console.log(color)
// 		console.log(num)
	});
</script>
<style>
	/* ul, li 초기화 */
	ul, li{
		margin: 0;
		padding: 0;
		list-style: none;
	}
	#searchDiv, #boardList{
		width: 1000px;
		margin: 0 auto;
	}
	#pagination{
		margin-left: 55px;
		width: 850px;
		float: left;
	}
	#searchDiv{
		margin-bottom: 20px;
	}
	#searchForm{
		float: right;
	}
	#boardList{
		height: 500px;
		text-align: center;
	}
	/* 게시판 요소 정렬 */
	#boardList li{
		float: left;
		width: 6%;
		height: 40px;
		line-height: 40px;
		border-bottom: 1px solid lightblue;
	}
	#boardList li:nth-child(7n+2){
		width: 50%;
	}
/* 	#boardList li:nth-child(5n+3){ */
/* 		width: 12%; */
/* 	} */
	#boardList li:nth-child(7n+4){
		width: 10%;
	}
	#boardList li:nth-child(7n+6){
		width: 15%;
	}
	.on{
		font-weight: bold;
	}
	.wordcut{
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		text-align: left;
	}
	#selectBox{
		height: 30px;
	}
	
</style>
</head>
<body>
	<div class="container">
		<div id="searchDiv">
			<h1>게시판</h1>
			
			<a href="boardWrite">글쓰기</a>
			<a href="/webapp/">전체목록</a>
			<form id="searchForm" action="/webapp/">
				<select id="selectBox" name="searchKey">
					<option value="subject">제목</option>
					<option value="content">글내용</option>
					<option value="userid">작성자</option>
				</select>
				<input type="text" name="searchWord">
				<input type="submit" value="검색">
			</form>
		</div>
		<ul id="boardList">
			<li>번호</li>
			<li>제목</li>
			<li>댓글</li>
			<li>글쓴이</li>
			<li>조회수</li>
			<li>등록일</li>
			<li>파일</li>
			
<%-- 											총 레코드 수 - ((현재 페이지-1)* 한 페이지 레코드 ) --%>
			<c:set var="recordNum" value="${totalRecord - ((page.currentPageNum-1) * page.onePageRecord)}"/>
			<c:forEach var="vo" items="${list}" varStatus="idx">
<%-- 				<c:if test="${vo.groupOrder==0}"> --%>
<%-- 					<c:if test="${idx.index == 0}"> --%>
<%-- 						<li>${recordNum}</li> --%>
<%-- 					</c:if> --%>
<%-- 					<c:if test="${idx.index != 0}"> --%>
<%-- 						<li>${recordNum+1}</li> --%>
<%-- 					</c:if> --%>
<%-- 				</c:if> --%>
<%-- 				<c:if test="${vo.groupOrder>0}"> --%>
<%-- 					<c:if test="${empty page.searchKey}"><li>${recordNum+vo.groupOrder}-${vo.groupOrder}</li></c:if> --%>
<%-- 					<c:if test="${not empty page.searchKey}"><li>${recordNum}</li></c:if> --%>
<%-- 				</c:if> --%>
				
				<li class="${vo.groupNo}" style="color:rgb(${vo.color});font-weight:bold;">${recordNum}</li>
				
<!-- 			// grouporder가 0이면 원글이니까 recordNum을 보여준다-->
<%-- 				<c:if test="${vo.groupOrder == 0}"><li>${recordNum}</li></c:if> --%>
<!-- 				// groupOrder가 0보다 크면 답글이니까 원글 recordNum에 '-'를 추가하고 순번이 나온다 -->
<%-- <%-- 				<c:if test="${vo.indent == 1}"><li>${recordNum+vo.groupOrder}-${vo.groupOrder}</li></c:if> --%>
<%-- 				<c:if test="${vo.indent > 1}"><li>${recordNum+vo.groupOrder}-${vo.groupOrder-vo.indent+1}-${vo.indent-1}</li></c:if> --%>


				<li class="wordcut">
				<c:forEach var="i" begin="1" end="${vo.indent}">
					&nbsp;&nbsp;&nbsp;&nbsp;
				</c:forEach>
				<c:if test="${vo.indent>0}">
					RE:&nbsp;
				</c:if>
				
				<a style="white-space: pre" href="boardView?boardNo=${vo.boardNo}&currentPage=1"><c:if test="${vo.state eq '공개'}"><c:out value="${vo.subject}" escapeXml="true"></c:out></c:if><c:if test="${vo.state eq '비공개'}">삭제된 글입니다.</c:if></a></li>
				<li><span id="commentNum">${commentNum[idx.index]}</span></li>
				<li><c:out value="${vo.userid}"></c:out></li>
				<li>${vo.hit}</li>
				<li>${vo.writedate}</li>
				<li> <c:if test="${vo.filename != null}">file</c:if></li>
				<c:set var="recordNum" value="${recordNum-1}"/>
			</c:forEach>	
			
		</ul>
		<div id="pagination">
			<c:if test="${page.totalRecord != null && page.totalRecord != ''}"><!-- 레코드가 없으면 첫페이지랑 < 안나와야한다 -->

				<c:if test="${page.currentPageNum!=1}"><!--1페이지가 아닐때만 첫페이지 버튼이 필요하다 -->
<%-- 					<a href="/webapp/?currnetPageNum=1<c:if test="${page.searchWord != null && page.searchWord != ''}">&searchKey=${page.searchKey}&searchWord=${page.searchWord}</c:if>">첫페이지</a> --%>
					<a href="" onclick="firstPage(); return false;">첫페이지</a>
				</c:if>
					
				<c:if test="${page.startPageNum!=1}"><!-- 시작페이지가 1이면 첫 페이지 세트이기때문에 페이지세트 이동 버튼이 필요없다 -->
					<a href="/webapp/?currentPageNum=${page.startPageNum-1}<c:if test="${page.searchWord != null && page.searchWord != ''}">&searchKey=${page.searchKey}&searchWord=${page.searchWord}</c:if>">&lt;</a>
				</c:if>
			</c:if>
			<c:forEach var="p" begin="${page.startPageNum}" end="${page.startPageNum+page.onePageNum-1}"><!-- 반복문의 시작은 시작페이지부터 끝은 끝페이지를 계산해서 설정 -->
			
				<c:if test="${p<=page.totalPage}"> <!-- 예를 들어 총 레코드가 16개일때 페이지는 4까지만 보여줘야한다 하지만 반복문에서는 그런 설정이 없다. 
				그래서 조건문으로 변수 p가 총페이지(마지막페이지)보다 같거나 작을때라는 조건을 걸어준다 -->
					<!-- 만약에 p가 4가돼면 예에서 처럼 마지막페이지인 4와 같아지기때문에 반복문은 돌지만 끝 페이지인 5는 찍히지 않는다-->
					<c:if test="${p==page.currentPageNum}">
						<a class="on" href="/webapp/?currentPageNum=${p}<c:if test="${page.searchWord != null && page.searchWord != ''}">&searchKey=${page.searchKey}&searchWord=${page.searchWord}</c:if>">${p}</a>
					</c:if>
					<c:if test="${p!=page.currentPageNum}">
						<a href="/webapp/?currentPageNum=${p}<c:if test="${page.searchWord != null && page.searchWord != ''}">&searchKey=${page.searchKey}&searchWord=${page.searchWord}</c:if>">${p}</a>
					</c:if>
				</c:if>
			</c:forEach>
			
			<c:if test="${page.totalRecord != null && page.totalRecord != ''}">
				<c:if test="${page.totalPage > page.endPage}"><!-- 총페이지수가 한 페이지세트 끝번호보다 크면  -->
					<a href="/webapp/?currentPageNum=${page.endPage+1}<c:if test="${page.searchWord != null && page.searchWord != ''}">&searchKey=${page.searchKey}&searchWord=${page.searchWord}</c:if>">&gt;</a>
				</c:if>
				
				<c:if test="${page.currentPageNum != page.totalPage}">
					<a href="/webapp/?currentPageNum=${page.totalPage}<c:if test="${page.searchWord != null && page.searchWord != ''}">&searchKey=${page.searchKey}&searchWord=${page.searchWord}</c:if>">마지막페이지</a>
				</c:if>
			</c:if>			
		</div>
	</div>
	<c:if test="${page.totalRecord != null && page.totalRecord != ''}">
		<form action="/webapp/excelDownload" method="post">
			<input type="hidden" name="searchKey" value="${page.searchKey}">
			<input type="hidden" name="searchWord" value="${page.searchWord}">
			<button id="excelDownload">엑셀로 다운 받기</button>
		</form>
	</c:if>
</body>
</html>

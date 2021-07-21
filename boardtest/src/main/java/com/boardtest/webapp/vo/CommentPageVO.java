package com.boardtest.webapp.vo;

public class CommentPageVO {
	private int onePageNum = 5;
	private int onePageRecord = 5;
	
	private int currentPage = 1;
	private int startPage = 1;
	private int endPage = 5;
	
	private int totalCommentNum;
	private int totalPageNum;
	private int lastPageCommentNum;
	
	public int getOnePageNum() {
		return onePageNum;
	}
	public void setOnePageNum(int onePageNum) {
		this.onePageNum = onePageNum;
	}
	public int getOnePageRecord() {
		return onePageRecord;
	}
	public void setOnePageRecord(int onePageRecord) {
		this.onePageRecord = onePageRecord;
	}
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
		
		//시작페이지 번호 계산
		startPage = ((currentPage-1)/onePageNum)*onePageNum+1;
		//페이지 세트에서 끝 페이지 계산
		endPage = startPage + 4;
	}
	public int getStartPage() {
		return startPage;
	}
	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	public int getTotalCommentNum() {
		return totalCommentNum;
	}
	public void setTotalCommentNum(int totalCommentNum) {
		this.totalCommentNum = totalCommentNum;
		
		//총 레코드수를 이용하여 총페이지를 계산
		totalPageNum = (int)Math.ceil(totalCommentNum/(double)onePageRecord);
		
		//마지막페이지 레코드 수
		if(totalCommentNum % onePageRecord==0) {
			lastPageCommentNum = onePageRecord;
		}else {
			lastPageCommentNum = totalCommentNum % onePageRecord; //마지막페이지의 남은 레코드 수
		}
	}
	public int getTotalPageNum() {
		return totalPageNum;
	}
	public void setTotalPageNum(int totalPageNum) {
		this.totalPageNum = totalPageNum;
	}
	public int getLastPageCommentNum() {
		return lastPageCommentNum;
	}
	public void setLastPageCommentNum(int lastPageCommentNum) {
		this.lastPageCommentNum = lastPageCommentNum;
	}	
}

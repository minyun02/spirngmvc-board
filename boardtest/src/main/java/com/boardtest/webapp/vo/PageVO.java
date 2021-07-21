package com.boardtest.webapp.vo;

import org.apache.ibatis.type.Alias;

@Alias("PageVO")
public class PageVO {
	private int onePageNum = 5; //한번에 보여질 페이지 수
	private int onePageRecord = 10; //한 페이지당 레코드 수
	
	private int currentPageNum = 1; //현재페이지
	private int startPageNum = 1; //시작페이지 번호
	private int endPage = 5;
	
	private int totalRecord; //총 레코드 수
	private int totalPage; //총 페이지 수 (마지막페이지)
	private int lastPageRecord; //마지막 페이지의 남은 레코드 수
	
	private String searchKey;
	private String searchWord;
	
	public int getCurrentPageNum() {
		return currentPageNum;
	}
	public void setCurrentPageNum(int currentPageNum) {
		this.currentPageNum = currentPageNum;
		
		//시작페이지 번호 계산
		startPageNum = ((currentPageNum-1)/onePageNum)*onePageNum+1;
		//페이지 묶음에서 끝 페이지 계산
		endPage = startPageNum + 4;
	}
	public int getOnePageNum() {
		return onePageNum;
	}
	public void setOnePageNum(int onePageNum) {
		this.onePageNum = onePageNum;
	}
	public int getTotalRecord() {
		return totalRecord;
	}
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
		
		//총 레코드수를 이용하여 총페이지를 계산
		totalPage = (int)Math.ceil(totalRecord/(double)onePageRecord);
		System.out.println("???");
		//마지막페이지 레코드 수
		if(totalRecord % onePageRecord==0) {
			lastPageRecord = onePageRecord;
		}else {
			lastPageRecord = totalRecord % onePageRecord; //마지막페이지의 남은 레코드 수
		}
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getStartPageNum() {
		return startPageNum;
	}
	public void setStartPageNum(int startPageNum) {
		this.startPageNum = startPageNum;
	}
	public int getOnePageRecord() {
		return onePageRecord;
	}
	public void setOnePageRecord(int onePageRecord) {
		this.onePageRecord = onePageRecord;
	}
	public int getLastPageRecord() {
		return lastPageRecord;
	}
	public void setLastPageRecord(int lastPageRecord) {
		this.lastPageRecord = lastPageRecord;
	}
	public String getSearchKey() {
		return searchKey;
	}
	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}
	public String getSearchWord() {
		return searchWord;
	}
	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
}

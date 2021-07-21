package com.boardtest.webapp.vo;

public class CommentVO {
	private int commentNo;
	private int boardNo;
	private String userid;
	private String password;
	private String content;
	private String writedate;
	private int cGroupNo;
	private int cGroupOrder;
	private int cIndent;
	
	
	public int getCommentNo() {
		return commentNo;
	}
	public void setCommentNo(int commentNo) {
		this.commentNo = commentNo;
	}
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWritedate() {
		return writedate;
	}
	public void setWritedate(String writedate) {
		this.writedate = writedate;
	}
	public int getcGroupNo() {
		return cGroupNo;
	}
	public void setcGroupNo(int cGroupNo) {
		this.cGroupNo = cGroupNo;
	}
	public int getcGroupOrder() {
		return cGroupOrder;
	}
	public void setcGroupOrder(int cGroupOrder) {
		this.cGroupOrder = cGroupOrder;
	}
	public int getcIndent() {
		return cIndent;
	}
	public void setcIndent(int cIndent) {
		this.cIndent = cIndent;
	}
}

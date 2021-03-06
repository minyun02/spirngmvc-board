package com.boardtest.webapp.vo;

public class BoardVO {
	private Integer boardNo;
	private String subject;
	private String content;
	private String userid;
	private String password;
	private int hit;
	private String filename;
	private String writedate;
	private String state;
	private String orifilename;
	
	//답변
	private int groupNo;
	private int groupOrder;
	private int indent;
	
	private int groupCount;
	private String color;
	
	public Integer getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(Integer boardNo) {
		this.boardNo = boardNo;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject.trim();
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid.trim();
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public int getHit() {
		return hit;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getWritedate() {
		return writedate;
	}
	public void setWritedate(String writedate) {
		this.writedate = writedate;
	}
	public int getGroupNo() {
		return groupNo;
	}
	public void setGroupNo(int groupNo) {
		this.groupNo = groupNo;
	}
	public int getGroupOrder() {
		return groupOrder;
	}
	public void setGroupOrder(int groupOrder) {
		this.groupOrder = groupOrder;
	}
	public int getIndent() {
		return indent;
	}
	public void setIndent(int indent) {
		this.indent = indent;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public int getGroupCount() {
		return groupCount;
	}
	public void setGroupCount(int groupCount) {
		this.groupCount = groupCount;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getOrifilename() {
		return orifilename;
	}
	public void setOrifilename(String orifilename) {
		this.orifilename = orifilename;
	}
}

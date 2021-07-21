package com.boardtest.webapp.service;

import java.util.List;

import com.boardtest.webapp.vo.BoardVO;
import com.boardtest.webapp.vo.CommentVO;
import com.boardtest.webapp.vo.PageVO;

public interface BoardService {
	public int boardInsert(BoardVO vo);
	public List<BoardVO> getList(PageVO pVo);
	public int getTotalRecord(PageVO pVo);
	public BoardVO getSelectedRecord(int boardNo);
	public String getPassword(int boardNo);
	public int boardEdit(BoardVO vo);
	public int boardDelete(int boardNo);
	public int updateHit(int boardNo);
	
	public BoardVO getOriInfo(int boardNo);
	public int replyInsert(BoardVO vo);
	public int indentCount(BoardVO vo);
	public int commentInsert(CommentVO cVo);
	public List<CommentVO> getCommentList(int boardNo, int currentPage, Integer totalPageNum, int lastPageCommentNum);
	public Integer commentCheck(int commentNo, String password);
	public Integer commentDel(int commentNo);
	public Integer getCommentNum(int boardNo);
	public Integer commentEdit(CommentVO cVo);
	public Integer childCommentDelete(int boardNo);
	public Integer getTotalCommentNum(int boardNo);
}

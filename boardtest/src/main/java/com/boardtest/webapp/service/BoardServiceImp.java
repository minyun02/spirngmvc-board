package com.boardtest.webapp.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.boardtest.webapp.dao.BoardDAO;
import com.boardtest.webapp.vo.BoardVO;
import com.boardtest.webapp.vo.CommentVO;
import com.boardtest.webapp.vo.PageVO;

@Service
public class BoardServiceImp implements BoardService {
	@Inject
	BoardDAO dao;
	
	@Override
	public int boardInsert(BoardVO vo) {
		// 글 등록
		return dao.boardInsert(vo);
	}

	@Override
	public List<BoardVO> getList(PageVO pVo) {
		// 글 목록가져오기
		return dao.getList(pVo);
	}

	@Override
	public int getTotalRecord(PageVO pVo) {
		// page용 총 레코드 수
		return dao.getTotalRecord(pVo);
	}

	@Override
	public BoardVO getSelectedRecord(int boardNo) {
		// 글 읽기
		return dao.getSelectedRecord(boardNo);
	}

	@Override
	public String getPassword(int boardNo) {
		// 글 수정 비번 확인
		return dao.getPassword(boardNo);
	}

	@Override
	public int boardEdit(BoardVO vo) {
		// 글 수정하기
		return dao.boardEdit(vo);
	}

	@Override
	public int boardDelete(int boardNo) {
		// 글 삭제
		return dao.boardDelete(boardNo);
	}

	@Override
	public int updateHit(int boardNo) {
		// 조회수 올리기
		return dao.updateHit(boardNo);
	}

	@Override
	public BoardVO getOriInfo(int boardNo) {
		// 원글 정보 가져오기
		return dao.getOriInfo(boardNo);
	}

	@Override
	public int replyInsert(BoardVO vo) {
		// 답글 등록하기
		return dao.replyInsert(vo);
	}

	@Override
	public int indentCount(BoardVO vo) {
		// indent update
		return dao.indentCount(vo);
	}

	@Override
	public int commentInsert(CommentVO cVo) {
		// comment insert
		return dao.commentInsert(cVo);
	}

	@Override
	public List<CommentVO> getCommentList(int boardNo, int currentPage, Integer totalPageNum, int lastPageCommentNum) {
		// 댓글 목록 불러오기
		System.out.println("lastPageCommentNum"+lastPageCommentNum);
		return dao.getCommentList(boardNo, currentPage, totalPageNum, lastPageCommentNum);
	}

	@Override
	public Integer commentCheck(int commentNo, String password) {
		// 댓글 수정 삭제 비번 확인
		return dao.commentCheck(commentNo, password);
	}

	@Override
	public Integer commentDel(int commentNo) {
		// 댓글 삭제
		return dao.commentDel(commentNo);
	}

	@Override
	public Integer getCommentNum(int boardNo) {
		// 댓글 수 가져오기
		return dao.getCommentNum(boardNo);
	}

	@Override
	public Integer commentEdit(CommentVO cVo) {
		// 댓글 수정
		return dao.commentEdit(cVo);
	}

	@Override
	public Integer childCommentDelete(int boardNo) {
		// 원글 삭제시 댓글도 지우기
		return dao.childCommentDelete(boardNo);
	}

	@Override
	public Integer getTotalCommentNum(int boardNo) {
		// 해당 글에 댓글이 몇개인지 찾아오기
		return dao.getTotalCommentNum(boardNo);
	}

}

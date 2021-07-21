package com.boardtest.webapp.controller;

import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.boardtest.webapp.service.BoardService;
import com.boardtest.webapp.vo.BoardVO;
import com.boardtest.webapp.vo.CommentPageVO;
import com.boardtest.webapp.vo.CommentVO;

@Controller
public class BoardController {
	
	@Inject
	BoardService boardService;
	
	@Autowired
	private DataSourceTransactionManager transactionManager;
	
	@RequestMapping("/boardView")
	public ModelAndView boardView(int boardNo, int currentPage, CommentPageVO cpVo) {
		ModelAndView mav = new ModelAndView();
		boardService.updateHit(boardNo);
		cpVo.setTotalCommentNum(boardService.getTotalCommentNum(boardNo));
		
		System.out.println(currentPage+"<--page");
		mav.addObject("vo", boardService.getSelectedRecord(boardNo));
		mav.addObject("cPage", cpVo);
		mav.setViewName("/board/boardView");
		return mav;
	}
	
	@RequestMapping("/boardWrite")
	public String boardWrite() {
		return "/board/boardWrite";
	}
	
	@RequestMapping(value="/boardWriteOk", method = RequestMethod.POST)
	public ModelAndView boardWriteOk(BoardVO vo) {
		ModelAndView mav = new ModelAndView();
		
		int result = boardService.boardInsert(vo);
		if(result > 0) { //글 등록 성공
			mav.setViewName("redirect:/");
		}else {
			mav.setViewName("redirect:boardWrite");
		}
		return mav;
	}
	
	@RequestMapping("/editCheck")
	@ResponseBody
	public int editCheck(int boardNo, String password) {
		int result = 0;
		String originalPwd = boardService.getPassword(boardNo);
		if(originalPwd.equals(password)) {
			result = 1;
		}
		return result;
	}
	
	@RequestMapping("/boardEdit")
	public ModelAndView boardEdit(int boardNo) {
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("vo", boardService.getSelectedRecord(boardNo));
		mav.setViewName("/board/boardEdit");
		return mav;
	}
	
	@RequestMapping(value="/boardEditOk", method = RequestMethod.POST)
	public ModelAndView boardEditOk(BoardVO vo) {
		ModelAndView mav = new ModelAndView();
		int updateResult = boardService.boardEdit(vo);
		if(updateResult > 0) {
			mav.setViewName("redirect:/");
		}else {
			mav.addObject("boardNo", vo.getBoardNo());
			mav.setViewName("redirect:boardEdit");
		}
		return mav;
	}
	
	@RequestMapping("/boardDelete")
	@Transactional(rollbackFor = {Exception.class, RuntimeException.class})
	public ModelAndView boardDelete(int boardNo) {
		//트랜잭션 객체 생성
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(DefaultTransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);	
		
		ModelAndView mav = new ModelAndView();
		try {
			int deleteResult = boardService.boardDelete(boardNo);
			boardService.childCommentDelete(boardNo);
			if(deleteResult>0) {
				mav.setViewName("redirect:/");
				transactionManager.commit(status);
			}else {
				mav.addObject("boardNo", boardNo);
				mav.setViewName("redirect:boardView");
				transactionManager.rollback(status);
			}
		}catch(Exception e) {
			mav.addObject("boardNo", boardNo);
			mav.setViewName("redirect:boardView");
			System.out.println("글 지우기 삭제 에러 발생 -----롤백");
			e.printStackTrace();
		}
		return mav;
	}
	
	//답글 쓰기 폼 
	@RequestMapping("/replyWrite")
	public ModelAndView replyWrite(Integer boardNo) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("boardNo", boardNo);
		mav.setViewName("/board/replyWrite");
		return mav;
	}
	
	//답글 쓰기
	@RequestMapping(value =  "/replyWriteOk", method = RequestMethod.POST)
	@Transactional(rollbackFor = {Exception.class, RuntimeException.class})
	public ModelAndView replyWriteOk(BoardVO vo) {
		//트랜잭션 객체 생성
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(DefaultTransactionDefinition.PROPAGATION_REQUIRED);
		
		TransactionStatus status = transactionManager.getTransaction(def);
		
		ModelAndView mav = new ModelAndView();
		try {
			//1. 원글의 정보 가져오기
			BoardVO oriVo = boardService.getOriInfo(vo.getBoardNo());
			System.out.println(oriVo.getGroupNo()+"groupno");
			System.out.println(oriVo.getGroupOrder()+"grouporder");
			System.out.println(oriVo.getIndent()+"indent");
			//2. 해당 답글에 정보 추가
			int indentCnt = boardService.indentCount(oriVo);
			//2-1 원글번호를 그룹번호 넣어줌
			vo.setGroupNo(oriVo.getGroupNo());
			//2-2 그룹순서 정해주기
			vo.setGroupOrder(oriVo.getGroupOrder()+1);
			//2-3 들여쓰기 정해주기
			vo.setIndent(oriVo.getIndent()+1);
			
			//답글 등록 메서드
			int replyInsert = boardService.replyInsert(vo);
			if(replyInsert>0) {//등록 성공
				mav.setViewName("redirect:/");
				transactionManager.commit(status);
			}else {//실패
				mav.setViewName("redirect:replyWrite");
				transactionManager.rollback(status);
			}
		}catch(Exception e) {
			mav.addObject("boardNo", vo.getBoardNo());
			mav.setViewName("redirect:replyWrite");
			System.out.println("답글 쓰기 에러 --- 롤백");
			e.printStackTrace();
		}
		return mav;
	}
	
	//댓글 insert
	@RequestMapping("/commentWriteOk")
	@ResponseBody
	public int commentWriteOk(CommentVO cVo) {
		int result = boardService.commentInsert(cVo);
		return result;
	}
	
	//댓글 목록 불러오기
	@RequestMapping("/commentList")
	@ResponseBody
	public List<CommentVO> commentList(int boardNo, int currentPage, Integer totalPageNum, int lastPageCommentNum){
		List<CommentVO> list = boardService.getCommentList(boardNo, currentPage, totalPageNum, lastPageCommentNum);
		System.out.println(currentPage+"<=현재페이지???????????????"+totalPageNum+"<=총페이지!!!!!!!!!!!!마지막레코드=>"+lastPageCommentNum);
		for(int i=0; i<list.size(); i++) {
			System.out.println("commentNo"+i+"===>"+list.get(i).getCommentNo());
		}
		return list;
	}
	
	//댓글 수정삭제 비번 확인
	@RequestMapping("/commentCheck")
	@ResponseBody
	public Integer commentDel(int commentNo, String password) {
		return boardService.commentCheck(commentNo, password);
	}
	
	//댓글 삭제
	@RequestMapping("/commentDel")
	@ResponseBody
	public Integer commentDel(int boardNo, int commentNo) {
		return boardService.commentDel(commentNo);
	}
	
	//댓글 수정
	@RequestMapping("/commentEdit")
	@ResponseBody
	public Integer commentEdit(CommentVO cVo) {
		System.out.println("boardno=>"+cVo.getBoardNo());
		System.out.println("commentno=>"+cVo.getCommentNo());
		System.out.println("userid=>"+cVo.getUserid());
		System.out.println("password=>"+cVo.getPassword());
		
		return boardService.commentEdit(cVo);
	}
}

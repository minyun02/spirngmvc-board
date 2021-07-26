package com.boardtest.webapp.controller;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor.HSSFColorPredefined;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
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
		System.out.println(vo.getSubject()+"?????????????????????????????????");
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
			//답글이 있는지를 확인한다 
			int replyCount = boardService.getReplyCount(boardNo);
//			int deleteResult = boardService.boardDelete(boardNo);
			int deleteResult = boardService.boardStateChange(boardNo); //글 삭제시 지우지말고 공개상태를 변경시키기 
			System.out.println(deleteResult+"!@#!#@!#!@#!@@#!");
//			boardService.childCommentDelete(boardNo); // 글 삭제할때 자식 댓글도 지우기
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
	
	//엑셀 다운로드
	@RequestMapping(value="/excelDownload", method =RequestMethod.POST)
	@ResponseBody
	public void excelDownload(String searchWord, String searchKey, HttpServletResponse res) {
		System.out.println(searchKey+"!!!!"+searchWord);
		
		List<BoardVO> excelList = boardService.getExcelList(searchKey, searchWord);
		List<Integer> commentNum = new ArrayList<Integer>(); 
		for(int i=0; i<excelList.size(); i++) {
			commentNum.add(boardService.getCommentNum(excelList.get(i).getBoardNo()));
		}
		try {
			//엑셀 워크북 생성
			Workbook workbook = new HSSFWorkbook();
			
			//시트 생성
			Sheet sheet = workbook.createSheet("게시판");
			
			//행, 열, 열번호
			Row row = null;
			Cell cell = null;
			int rowNo = 0;
			
			//엑셀 테이블 헤더
			CellStyle header = workbook.createCellStyle();
			//배경 노란색
			header.setFillBackgroundColor(HSSFColorPredefined.AQUA.getIndex());
//			header.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			//데이터 테두리
			CellStyle body = workbook.createCellStyle();
			body.setBorderTop(BorderStyle.THIN);
			body.setBorderRight(BorderStyle.THIN);
			body.setBorderBottom(BorderStyle.THIN);
			body.setBorderLeft(BorderStyle.THIN);
			
			//헤더 이름 설정
			String[] headerArray = {"번호", "제목", "내용", "작성자", "댓글수", "조회수", "등록일"};
			//헤더가 들어갈 로우 생성(1번째 로우)
			row = sheet.createRow(rowNo++);
			for(int i=0; i<headerArray.length; i++) {
				cell = row.createCell(i);
				cell.setCellStyle(header);
				cell.setCellValue(headerArray[i]);
			}
			//body 넣어주기
			int num = excelList.size();
			for(int i=0; i<excelList.size();i++) {
				//1. 번호 넣어주기
				row = sheet.createRow(rowNo+i);
				cell = row.createCell(0); // 첫번째 칼럼이니까 0
				cell.setCellStyle(body); //
//				cell.setCellValue(excelList.get(i).getBoardNo()); 
//				if(excelList.get(i).getGroupOrder() == 0) {
					cell.setCellValue(num--); 
//				}else {
//					cell.setCellValue((num--)+excelList.get(i).getGroupOrder() +"-"+excelList.get(i).getGroupOrder());
//				}
				rowNo = 1;
				//2. 제목 넣어주기
				cell = row.createCell(1); 
				cell.setCellStyle(body);
				cell.setCellValue(excelList.get(i).getSubject()); 
				rowNo = 1;
				//3. 내용 넣어주기
				cell = row.createCell(2); 
				cell.setCellStyle(body);
				cell.setCellValue(excelList.get(i).getContent()); 
				rowNo = 1;
				//4. 작성자 넣어주기
				cell = row.createCell(3); 
				cell.setCellStyle(body);
				cell.setCellValue(excelList.get(i).getUserid()); 
				rowNo = 1;
				//5. 댓글수 넣기
				cell = row.createCell(4); 
				cell.setCellStyle(body);
				cell.setCellValue(commentNum.get(i)); 
				rowNo = 1;
				//6. 조회수 넣기
				cell = row.createCell(5); 
				cell.setCellStyle(body);
				cell.setCellValue(excelList.get(i).getHit()); 
				rowNo = 1;
				//7. 등록일 넣기
				cell = row.createCell(6);
				cell.setCellStyle(body);
				cell.setCellValue(excelList.get(i).getWritedate()); 
				rowNo = 1;
			}
			
			
			//컨텐츠 타입과 파일명 지정
			res.setContentType("ms-vnd/excel");
			res.setHeader("Content-Disposition", "attachment; filename="+ java.net.URLEncoder.encode("게시판.xls", "UTF8"));
			//엑셀 출력
			workbook.write(res.getOutputStream());
			workbook.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}

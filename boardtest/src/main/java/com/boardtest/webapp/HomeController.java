package com.boardtest.webapp;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.boardtest.webapp.service.BoardService;
import com.boardtest.webapp.vo.BoardVO;
import com.boardtest.webapp.vo.PageVO;

@Controller
public class HomeController {
	@Inject
	BoardService boardService;
	
//	@RequestMapping(value = {"/", "list"}, method = RequestMethod.GET)
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home(PageVO pVo) {
		ModelAndView mav = new ModelAndView();
		pVo.setTotalRecord(boardService.getTotalRecord(pVo));
		
		List<BoardVO> list = boardService.getList(pVo);
		
		//댓글수 저장하기
		List<Integer> commentNum = new ArrayList<Integer>(); 
		for(int i=0; i<list.size(); i++) {
			commentNum.add(boardService.getCommentNum(list.get(i).getBoardNo()));
		}
		
		//groupOrder 받아와서 게시글 정렬에 이용해야해서 역순으로 담아주기
		int order = list.size()-1;
		System.out.println(order+"!!!!!!!!!!!!!!!");
		List<Integer> groupOrder = new ArrayList<Integer>();
		for(int i=0; i<list.size(); i++) {
			groupOrder.add(list.get(order).getGroupOrder());
			System.out.println(list.get(i).getBoardNo()+"= order->"+groupOrder.get(i).toString());
			order--;
		}
		mav.addObject("totalRecord", pVo.getTotalRecord());
		mav.addObject("list", list);
		mav.addObject("commentNum", commentNum);
		mav.addObject("order",groupOrder);
		mav.addObject("page", pVo);
		mav.setViewName("home");
		
		return mav;
	}
	
}

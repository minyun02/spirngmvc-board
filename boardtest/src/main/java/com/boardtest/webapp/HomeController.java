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
		List<Integer> commentNum = new ArrayList<Integer>(); 
		for(int i=0; i<list.size(); i++) {
			commentNum.add(boardService.getCommentNum(list.get(i).getBoardNo()));
		}
		
		mav.addObject("totalRecord", pVo.getTotalRecord());
		mav.addObject("list", list);
		mav.addObject("commentNum", commentNum);
		mav.addObject("page", pVo);
		mav.setViewName("home");
		
		return mav;
	}
	
}

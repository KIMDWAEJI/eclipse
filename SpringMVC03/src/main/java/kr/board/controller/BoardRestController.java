package kr.board.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.Board;
import kr.board.mapper.BoardMapper;

@RequestMapping("/board")
@RestController	// 기본으로 @ResponseBody 적용(생략 가능)
public class BoardRestController {

	@Autowired
	BoardMapper boardMapper;
	
	@GetMapping("/all")
	public List<Board> boardList() {	// @ResponseBody: jackson-databind(객체를 JSON 데이터 형식으로 변환)
		List<Board> list = boardMapper.getLists();
		
		return list;	// JSON 데이터 형식으로 변환(API) 후 리턴(응답)
	}
	
	@PostMapping("/new")
	public void boardInsert(Board vo) {
		boardMapper.boardInsert(vo);
	}
	
	@DeleteMapping("/{idx}")
	public void boardDelete(@PathVariable("idx") int idx) {
		boardMapper.boardDelete(idx);
	}
	
	@PutMapping("/update")
	public void boardUpdate(@RequestBody Board vo) {
		boardMapper.boardUpdate(vo);
	}
	
	@GetMapping("/{idx}")
	public Board boardContent(@PathVariable("idx") int idx) {
		Board vo = boardMapper.boardContent(idx);
		
		return vo;	// vo -> json
	}
	
	@PutMapping("/count/{idx}")
	public Board boardCount(@PathVariable("idx") int idx) {
		boardMapper.boardCount(idx);
		Board vo = boardMapper.boardContent(idx);
		
		return vo;
	}
	
}

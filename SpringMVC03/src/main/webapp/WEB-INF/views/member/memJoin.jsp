<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<title>Bootstrap Example</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script type="text/javascript">

	// 회원가입 성공 여부 메시지
	$(document).ready(function() {
		if(${!empty msgType}) {
			$("#messageType").attr("class", "modal-content panel-warning");
			$("#myMessage").modal("show");
		}
	});

	// 아이디 중복 확인 함수
	function registerCheck() {
		var memID = $("#memID").val();
		$.ajax({
			url : "${contextPath}/memRegisterCheck.do",
			type : "get",
			data : {
				"memID" : memID
			},
			success : function(result) {
				// 중복유무 출력 (result = 1: 사용 가능, 0 : 사용 불가)
				if (result == 1) {
					$("#checkMessage").html("사용 가능한 아이디입니다.");
					$("#checkType")
							.attr("class", "modal-content panel-success")
				} else {
					$("#checkMessage").html("사용이 불가능한 아이디입니다.");
					$("#checkType")
							.attr("class", "modal-content panel-warning")
				}
				$("#myModal").modal("show");
			},
			error : function() {
				alert("error");
			}
		});
	}

	// 비밀번호 확인 함수
	function passwordCheck() {
		var memPW01 = $("#memPW01").val();
		var memPW02 = $("#memPW02").val();
		if (memPW01 != memPW02) {
			$("#passMessage").html("비밀번호가 일치하지 않습니다.");
		} else {
			$("#passMessage").html("");
			$("#memPW").val(memPW01);
		}
	}
	
	function goInsert() {
		var memAge=$("#memAge").val();
		if(memAge == null || memAge == "") {
			alert("나이를 입력하세요.");
			
			return false;
		}
		document.frm.submit();	// 전송
	}

</script>
</head>
<body>
	<div class="container">
	<jsp:include page="../common/header.jsp" />
	<h2>Spring MVC03</h2>
	<div class="panel panel-default">
		<div class="panel-heading">회원가입</div>
		<div class="panel-body">
			<form name="frm" action="${contextPath}/memRegister.do" method="post">
				<input type="hidden" id="memPW" name="memPW" />
				<table class="table table-bordered"
					style="text-align: center; border: 1px solid #dddddd">
					
					<tr>
						<td style="width: 110px; vertical-align: middle">아이디</td>
						<td>
							<input id="memID" name="memID" class="form-control" type="text" maxlength="20" placeholder="아이디를 입력하세요" />
						</td>
						<td style="width: 110px">
							<button type="button" class="btn btn-primary btn-sm" onclick="registerCheck()">중복확인</button>
						</td>
					</tr>

					<tr>
						<td style="width: 110px; vertical-align: middle">비밀번호</td>
						<td colspan="2">
							<input id="memPW01" name="memPW01" class="form-control" type="password" maxlength="20" placeholder="비밀번호를 입력하세요" onkeyup="passwordCheck()" />
						</td>
					</tr>

					<tr>
						<td style="width: 110px; vertical-align: middle">비밀번호 확인</td>
						<td colspan="2">
							<input id="memPW02" name="memPW02" class="form-control" type="password" maxlength="20" placeholder="비밀번호를 확인하세요" onkeyup="passwordCheck()" />
						</td>
					</tr>

					<tr>
						<td style="width: 110px; vertical-align: middle">이름</td>
						<td colspan="2">
							<input id="memName" name="memName" class="form-control" type="text" maxlength="20" placeholder="이름을 입력하세요" />
						</td>
					</tr>

					<tr>
						<td style="width: 110px; vertical-align: middle">나이</td>
						<td colspan="2">
							<input id="memAge" name="memAge" class="form-control" type="number" maxlength="20" placeholder="나이를 입력하세요" />
						</td>
					</tr>

					<tr>
						<td style="width: 110px; vertical-align: middle">성별</td>
						<td colspan="2">
							<div class="form-group" style="text-align: center;">
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-primary active">
										<input id="memGender" name="memGender" type="radio" autocomplete="off" value="남자" checked />남자
									</label>
									<label class="btn btn-primary">
										<input id="memGender" name="memGender" type="radio" autocomplete="off" value="여자" />여자
									</label>
								</div>
							</div>
						</td>
					</tr>

					<tr>
						<td style="width: 110px; vertical-align: middle">이메일</td>
						<td colspan="2">
							<input id="memEmail" name="memEmail" class="form-control" type="email" maxlength="20" placeholder="이메일을 입력하세요"/>
						</td>
					</tr>

					<tr>
						<td colspan="3" style="text-align: left">
							<span id="passMessage" style="color: red"></span>
							<input type="button" class="btn btn-primary btn-sm pull-right" value="등록" onclick="goInsert()" />
						</td>
					</tr>
					
				</table>
			</form>	
		</div>
		
		<!-- 다이얼로그(모달) -->
		<!-- Modal -->
		<div id="myModal" class="modal fade" role="dialog">
			<div class="modal-dialog">

				<!-- Modal content-->
				<div id="checkType" class="modal-content">
				
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title">메시지 확인</h4>
					</div>
					
					<div class="modal-body">
						<p id="checkMessage"></p>
					</div>
					
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					</div>
					
				</div>

			</div>
		</div>
		
		<!-- 실패 메시지 출력(모달) -->
		<div id="myMessage" class="modal fade" role="dialog">
			<div class="modal-dialog">

				<!-- Modal content-->
				<div id="messageType" class="modal-content">
				
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title">${msgType}</h4>
					</div>
					
					<div class="modal-body">
						<p>${msg}</p>
					</div>
					
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					</div>
					
				</div>

			</div>
		</div>
		
		<div class="panel-footer">Panel Footer</div>
	</div>
	</div>

</body>
</html>

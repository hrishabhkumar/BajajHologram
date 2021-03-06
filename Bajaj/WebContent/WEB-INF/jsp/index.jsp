<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
 String loginModule = (String)session.getAttribute("firstname");
if(loginModule == null)
{
	response.sendRedirect("./");
}
 %>
<!doctype html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>
<link href="lib/css/bootstrap.css" rel="stylesheet">
<link rel="stylesheet" type="text/stylesheet" href="lib/css/jquery.dataTables.css">
<link rel="stylesheet" type="text/stylesheet" href="lib/css/jquery-ui.min.css">
<link rel="stylesheet" type="text/stylesheet" href="css/reset.css">
<link rel="stylesheet" type="text/stylesheet" href="css/style.css">
<link rel="stylesheet" type="text/stylesheet" href="css/styles.css">
<script type="text/javascript">
	var fName = '<%=loginModule%>';
</script>
<title>Home</title>
</head>
<body>
	<!-------------------- Nav Bar ------------->

	<jsp:include page="header.jsp"></jsp:include>
    <div class="navbar  navbar-default" id="theme-header"> 
	    <div class="container">
		  <h1>
		    <a href="./index.do" class="navbar-brand">Support</a>
		  </h1>
	    </div>
    </div>
    <div id="live-search">
    <div class="container">
    <div id="search-wrap">
      <form role="search" method="get" id="searchform" class="clearfix" action="#" autocomplete="off">
        <input type="text" onfocus="if (this.value == &#39;Have a question? Ask or enter a search term.&#39;) {this.value = &#39;&#39;;}" onblur="if (this.value == &#39;&#39;)  {this.value = &#39;Have a question? Ask or enter a search term.&#39;;}" value="Have a question? Ask or enter a search term." name="s" id="s" autocomplete="off">
        <input type="submit" id="searchsubmit" value="Search">
      </form>
      </div>
    </div>
    </div>
	<!-- Body Part -->
	<div class="container" id="questionContainer"></div>
	<!-- Login -->

	

	<!----------------        Inbox      ------------------>
	<script type="text/template" id='question-template'>
		  <div class=container >
		 
		  	<div class="navbar"style="padding-right:10px;">
	        	<ul class="nav nav-pills navbar-left input_element">
		        	<li><a class="btn btn-default btn-sm" data-toggle="modal" data-target="#new-questions" id="add-new-question-btn">+ New Question</a></li>
	        	</ul>
        	</div>
        	<div class="container tab-body" id="questionList">
        		
        	</div>
		  </div>
		  </script>
	<!-----------        QuestionList       ------------>
<script type="text/template" id="questionListTemplate">
<table class="table table-stripped" id=qustion-table>
    <thead>
       <tr>
        <th>QuestionList</th>
       </tr>
   </thead>
  <tbody ><@console.log(QACollection);@>
  	<@if(QACollection.length >0){ @>
		<@_.each(QACollection.models, function(QAModel){@>
		<tr>
		  	<td>
				<ul>
					<span class="col-sm-1"><button id="<@=QAModel.id@>" class="expand_listBtn"><i class="glyphicon glyphicon-plus"></i></button></span>
					<span class="col-sm-11">
					<li class="question"><@=QAModel.get('question')@></li>
					<li id="answer_<@=QAModel.id@>" class="answer" style="display:none"><@=QAModel.get('answer')@></li>
					</span>
				</ul>
			</td>
		</tr>
		<@});} else { @>
			<tr>
		  	<td>
				<ul>
					
					<li class="NoQuestion">No Frequent Question added yet !</li>
					
					</span>
				</ul>
			</td>
		</tr>
		<@}@>
  </tbody>
</table>
</script>

<script type="text/template" id="questionDetailTemplate">
<div class="modal-header">
	<span class="glyphicon glyphicon-remove pull-right"
		data-dismiss="modal"></span>
	<h4 class="modal-title">Your Question with Answer</h4>
</div>
<div class="modal-body" >
	<p class="text-justify" style="font-size: 14px;"><@=model.get('question')@></p>
	<p class="text-justify" style="font-size: 14px;"><@=model.get('answer')@></p>
	<div class="modal-footer">
		<div class=center-block>
			<a class="btn btn-default" data-dismiss="modal">OK</a>
			<a class="btn btn-default" data-dismiss="modal" id="EditQA">Edit</a>
		</div>
	</div>
</div>
</script>
<script type="text/template" id="questionEditTemplate">
<div class="modal-header">
<@console.log(model.get('frequent'));@>
	<span class="glyphicon glyphicon-remove pull-right"
		data-dismiss="modal"></span>
	<h4 class="modal-title"><@= model.id == undefined ? "Save" : "Update"@> Your Question</h4>
</div>
				<div class="modal-body" >
<form class="form" role=form>
		<div class="form-group" id=question_form>
			<label for="question">Question</lable>
		</div>
		<div class="form-group">
			<textarea placeholder="Question" id="question" name = "question" class="form-control"><@=model.get('question')@></textarea>
		</div>
		<div class="form-group">
			<label for="answer">Answer</lable>
		</div>
		<div class="form-group">
			<textarea placeholder="Answer"
				id="answer" class="form-control"><@=model.get('answer')@></textarea>
		</div>
		<div class="form-group">
			<label for="frequency">Is It frequent? </lable>
		</div>
		<div class="form-group">
			<select id="qFrequency" class="form-control">	
				<option value="0" <@= model.get('frequent') == "0" ? "selected" : ""@>>No</option>
				<option value="1" <@= model.get('frequent') == "1" ? "selected" : ""@>>Yes</option>
			</select>
		</div>
		<input name="id" id="qId" type="hidden" value="<@=model.id@>"/>
		<div class="form-group">
			<a  id = saveQA class="btn btn-success" data-dismiss="modal">+ <@= model.id == undefined ? "Save" : "Update"@> Question</a>
		</div>

	</form>
	</div>
</script>
	<!-- Modal For Alert -->
	<div class="modal fade" id="QADeatailModal" role="dialog">
		<div class="modal-dialog modal-vertical-centered">
			<div class="modal-content" id="QAModal">
			</div>
		</div>
	</div>
	<div class="modal fade" id="signInModal" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h1>Sign In</h1>
				</div>
				<div class="modal-body">
					If you are already registered please enter:
					<form class="form" role=form id=loginForm>
						<div class="form-group">
							<label for="username">User Name:</label> <input type="text"
								placeholder="Email" class="form-control" name="username"
								id="username"> <span id="userNameSpan"
								class="help-block"></span>
						</div>
						<label for="password">Password:</label>
						<div class="form-group">
							<input type="password" placeholder="Password"
								class="form-control" name="password" id="password"> <span
								id="logInPassSpan" class="help-block"></span>
						</div>
						<div class="form-group">
							<a id="signIn" class="btn btn-success">Sign in</a>
							<button type="reset" class="btn btn-default">Reset</button>
						</div>
					</form>
				</div>
				<div class="modal-footer">
				</div>
			</div>
		</div>
	</div>
		<script type="text/javascript" src="lib/js/underscore-min.js"></script>
		<script type="text/javascript" src="lib/js/jquery-1.10.2.js"></script>
		<script type="text/javascript" src="lib/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="lib/js/backbone-min.js"></script>
		<script type="text/javascript" src="lib/js/jquery.dataTables.js"></script>
		<script type="text/javascript" src="lib/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="js/commonFunction.js"></script>
		<!-- Model -->
		<script type="text/javascript" src="js/model/QAModel.js"></script>
		
		<!-- Collection -->
		<script type="text/javascript" src="js/collection/QACollection.js"></script>
		
		<!-- View -->
		<script type="text/javascript" src="js/view/QuestionDetailView.js"></script>
		<script type="text/javascript" src="js/view/QuestionListView.js"></script>
		<script type="text/javascript" src="js/view/QuestionBaseView.js"></script>
		
		
		<!-- Router -->
		<script type="text/javascript" src="js/ApplicationRouter.js"></script>
		
		<script type="text/javascript">
		$(document).ready(function(){
			$('#home').addClass('active');
		});

</script>
  	</body>
</html>
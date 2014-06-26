var activity = [];

this.defaultActivity = function(){
	activity = new Array();
	activity.type = $("input:radio[name=activityGroup]:checked").val();//$("#activityDropdown").val();
	activity.question = "";
	activity.instruction = "";
	activity.optionColl = new Array();
	activity.answerColl = new Array();
	renderOptions(this.activity.type);
	activityCollection.push(activity);
};


this.renderActivityData = function(activityData){
	//activity = new Array();
	if(activityData){
		activity.question = activityData.question;
		activity.instruction = activityData.instruction;
		activity.type = activityData.type;
		//$("#activityDropdown").val(activityData.type);
		$("input:radio[name=activityGroup][value="+activityData.type+"]").attr('checked', 'checked');
		$("#questionInput").val(activityData.question);
		$("#instructionInput").val(activityData.instruction);
		activity.optionColl = activityData.optionColl;
		activity.answerColl = activityData.answerColl;
		renderOptions(activity.type, activity.optionColl, activity.answerColl);
	}
	else{
		this.defaultActivity();
	}
	if(activityCollection.length > 1) $("#deleteActivityBtn").button("enable");
	else $("#deleteActivityBtn").button("disable");
};

this.renderOptions = function(activityType, optionColl, answerCall){
	activity.type = activityType;
	if(!optionColl){ activity.optionColl = new Array(); activity.answerColl = new Array(); }
	$("#optionContainer ul").html("");
	var inputType = 'radio';
	var optionCount = 2;
	switch(activityType){
		case "MCSS": inputType = 'radio'; optionCount = 4;
					break;
		case "MCMS": inputType = 'checkbox'; optionCount = 4;
					break;
		case "TF": inputType = 'radio'; optionCount = 2;
					if(activityCollection.length && activityCollection[selectedTab].optionColl && activityCollection[selectedTab].optionColl.length == 4)
						activityCollection[selectedTab].optionColl.splice(2,2);
					break;
	}
	if(optionColl && optionColl.length) optionCount = optionColl.length;
	/********************Option Creation***********************************/
	for (var i=0; i < optionCount; i++) {
		var answerVal = "false";
		if(answerCall) answerVal = answerCall[i];
		var tempId = "option"+new Date().getTime();
		var optElem = $("<li><input type='"+inputType+"' id='"+tempId+"' name='option' data-answer-state='"+ answerVal +"' onclick= 'changeAnswerState(event)' /><input type='text' class='option' for='"+tempId+"' value='Option "+(i+1)+"'/><button class='deleteOption' onclick='deleteOption(event)' /></li>");
		if(answerVal == "true")
			$(optElem).find('input[name="option"]').attr('checked','checked');
		if(optionColl && optionColl.length){
			$(optElem).find("input[type=text]").val(optionColl[i]);
		}
		$("#optionContainer ul").append(optElem);
		if(!optionColl){
			activity.optionColl.push($(optElem).find("input[type=text]").val());
			activity.answerColl.push($(optElem).find('input[name="option"]').attr('data-answer-state'));
		}
	};
	/*********************************************************************/
	//activityCollection[selectedTab] = Array(this.activity);
	$("#acitivityContent input[type='text']").on('paste cut input',updateActivityCollection);
	$("#acitivityContent textarea").on('paste cut input',updateActivityCollection);
	if(activity.type == "TF"){
		$("#addOptionBtn").hide();
		$(".deleteOption").hide();
	}
	else{
		$("#addOptionBtn").css("display", "");
		$(".deleteOption").css("display", "");
	}
};

this.changeAnswerState = function(event){
	var $target = $(event.target);
	var index = $target.closest("li").index();
	if($target.attr('type') == 'radio')
	{	
		if($target.attr('checked') == 'checked'){
			$target.closest('ul').find('input[type="radio"]').attr('data-answer-state','false');
			$target.attr('data-answer-state','true');
		}
		else
			$target.attr('data-answer-state','false');
			
		$target.closest("ul").find('li').each(function(index, value){
			activityCollection[selectedTab].answerColl[index] = $(value).find('input[name="option"]').attr('data-answer-state');
	    });
	    
	} else if($target.attr('type') == 'checkbox') {
		
		if($target.attr('checked') == 'checked')
			$target.attr('data-answer-state','true');
		else 
			$target.attr('data-answer-state','false');
		
		activityCollection[selectedTab].answerColl[index] = $target.attr('data-answer-state');
	}

};

this.updateActivityCollection = function(event){
		var tempActivity = activityCollection[selectedTab];
		if($(event.target).attr("class") == 'option'){
			var indx = $(event.target).closest("li").index();
			tempActivity.optionColl[indx] = $(event.target).val();
			tempActivity.answerColl[indx] = $(event.target).attr('data-answer-state');
		}
		else{
			tempActivity[$(event.target).attr("class")] = $(event.target).val();
		}
		//event.preventDefault();
};
this.deleteOption = function(event){
	if($("#optionContainer li").length <= 2 )return false;
	var indx = $(event.target).closest("li").index();
	activityCollection[selectedTab].optionColl.splice(indx,1);
	$(event.target).closest("li").remove();
};
this.openActivityPanel = function(){
	$(".tabs").find("li").addClass("activeTab");
	activityCollection = new Array();
	$("#activityPanel").show();
	if(activityCollection.length){
		renderActivityData(activityCollection[0]);
	}
	else renderActivityData();
	$("#preloaderBackground").show();
};
this.addQuestion = function(){
	var tabCount = $(".tabs").find("a").length;
	if(tabCount < 5)$(".tabs").append("<li><a href='#'>Activity "+(tabCount+1)+"</a></li>");
	if(tabCount == 4) $("#addQuestionBtn").attr("disabled","true");
	else $("#addQuestionBtn").removeAttr("disabled");
	/*var dropdown = document.getElementById("activityDropdown"); 
	dropdown.selectedIndex=0;*/
	$("input:radio[name=activityGroup][value=MCSS]").attr('checked', 'checked');
	this.defaultActivity();
	selectedTab = tabCount;
	openSelectedActivity();
	if(activityCollection.length > 1) $("#deleteActivityBtn").button("enable");
	else $("#deleteActivityBtn").button("disable");
};
this.openSelectedActivity = function(event){
	$(".tabs").find("li").removeClass("activeTab");
	if(event){
		var currentSelectedTab = $(event.currentTarget).index();
		$(event.currentTarget).addClass("activeTab");
		selectedTab = $(event.currentTarget).index();
	}
	else $(".tabs li:eq("+selectedTab+")").addClass("activeTab");
	activity = new Array();
	activity = activityCollection[selectedTab];
	renderActivityData(activity);
};
this.changeActivityType = function(dropdown){
	activity.type = $(dropdown).val();
	renderOptions($(dropdown).val());
	if(activity.type == "TF"){
		$("#addOptionBtn").hide();
		$(".deleteOption").hide();
	}
	else{
		$("#addOptionBtn").css("display", "");
		$(".deleteOption").css("display", "");
	}
};
this.onActivityCloseClicked = function(){
	$("#activityPanel").hide();
	$("#preloaderBackground").hide();
	activityCollection = [];
	clearActivity();
	$(".tabs").find("li:not(:first-child)").remove();
};
this.addOption = function(){
	var inputType;
	var activityType = $("input:radio[name=activityGroup]:checked").val();//$('#activityDropdown').val();
	switch(activityType){
		case "MCSS": inputType = 'radio';
					break;
		case "MCMS": inputType = 'checkbox';
					break;
		case "TF": inputType = 'radio';
					break;
	}
	var tempId = "option"+new Date().getTime();
	var optElem = $("<li><input type='"+inputType+"' id='"+tempId+"' name='option' data-answer-state='false' onclick= 'changeAnswerState(event)' /><input type='text' class='option' for='"+tempId+"' value='Option "+($("#optionContainer ul li").length+1)+"' /><button class='deleteOption' onclick='deleteOption(event)' /></li>");
	$("#optionContainer ul").append(optElem);
	activityCollection[selectedTab].optionColl.push($(optElem).find(".option").val());
	activityCollection[selectedTab].answerColl.push($(optElem).find(".option").attr('data-answer-state'));
	$(optElem).find(".option").on('keyup',updateActivityCollection);
};
this.convertObjToHTML = function(){
	var activityType, inputType='radio', isExist = false, activityPanelCK;
	if(activity.id){
		isExist = $(ckeditorDoc).find("#"+activity.id).length? true : false;
		activityPanelCK = $(ckeditorDoc).find("#"+activity.id).closest("div");
	}
	else activityPanelCK = $("<div data-type='activity' data-markup='yes' contenteditable='false'/>");
	for (var i=0; i < activityCollection.length; i++) {
		activityType = activityCollection[i].type;
		switch(activityType){
			case "MCSS": inputType = 'radio';
						break;
			case "MCMS": inputType = 'checkbox';
						break;
			case "TF": inputType = 'radio';
						break;
		}
		var tmpstmp = new Date().getTime();
	  	var elem = $('<li><label for="question'+tmpstmp+'"></label><label id="question'+tmpstmp+'" class="question" >'+activityCollection[i].question+'</label></li>'
						+'<li><label for="instruction'+tmpstmp+'"></label><label id="instruction'+tmpstmp+'" class="instruction" >'+activityCollection[i].instruction+'</label></li>'
						+'<li><label for="optionContainer'+tmpstmp+'" > </label><div id="optionContainer'+tmpstmp+'" class="optionContainer"><ul></ul></div></li>');
	  	for (var j=0; j < activityCollection[i].optionColl.length; j++) {
	  		var tempId = "option"+new Date().getTime();
			var opt = $('<li><input type='+inputType+' id='+tempId+' name="option" data-answer-state="'+activityCollection[i].answerColl[j]+'"/><label for='+tempId+' class="option" >'+activityCollection[i].optionColl[j]+'</label></li>');
			$(elem).find("ul").append(opt);
		  };
		  var tempId = "activity_"+ new Date().getTime();
		  var activityContentCK = $("<div id="+tempId+" data-type="+activityType+" class='activity'><button class='deleteActivityBtnCK' onclick='deleteActivityCK()'></button><button class='editActivityBtnCK'></button></div>");
		  $(activityContentCK).append(elem);
		  var activityBtnElem = $("<div id='activityButtonBarCK"+new Date().getTime()+"' style='text-align: center;'><button id='showBtnCK"+new Date().getTime()+"' class='showBtnCK' onclick='showSolution(event)'>Show</button><button class='submitBtnCK' onclick='submitSolution(event)' id='submitBtnCK"+new Date().getTime()+ "' >Submit</button></div>");
		  $(activityContentCK).append(activityBtnElem);
		  if(isExist) $("#"+activity.id).replaceWith($(activityContentCK));
		  else $(activityPanelCK).append($(activityContentCK));
	};
	if(!isExist) editor.insertHtml($(activityPanelCK)[0].outerHTML);
	//$(ckeditorDoc).find("#activityPanelCK li").css("list-style","none");
	//$(ckeditorDoc).find("#activityPanelCK > div").css("border","1px dashed #00a9e2");
	$(ckeditorDoc).find(".editActivityBtnCK").on("click", onEditClicked);
	$(ckeditorDoc).find("button.showBtnCK").on("click", showSolution);
	$(ckeditorDoc).find("button.submitBtnCK").on("click", submitSolution);
	$(ckeditorDoc).find(".deleteActivityBtnCK").on("click", deleteActivityCK);
};

this.onActivitySubmit = function(){
	convertObjToHTML();
	onActivityCloseClicked();
};
this.onEditClicked = function(){
	activityCollection = [];
	activity = [];
	selectedTab = 0;
	var activityElem = $(this).closest("div");
	activity.type = $(activityElem).attr("data-type");
	activity.id = $(activityElem).attr("id");
	activity.question = $(activityElem).find(".question").text();
	activity.instruction = $(activityElem).find(".instruction").text();
	activity.optionColl = [];
	activity.answerColl = [];
	var optionElem = $(activityElem).find(".optionContainer li");
	$(optionElem).each(function(){
		var optVal = $(this).find("label").text();
		activity.optionColl.push(optVal);
		activity.answerColl.push($(this).find('input[name="option"]').attr('data-answer-state'));
	});
	activityCollection.push(activity);
	$(".tabs").find("li:not(:first-child)").remove();
	renderActivityData(activity);
	$("#activityPanel").show();
	$("#preloaderBackground").show();
	$(".tabs").find("li").addClass("activeTab");
};
this.deleteActivityCK = function(){
	$(this).closest("div").remove();
	isEdited = true;
	$("#btnSave").button("enable");
};
this.clearActivity = function(){
	$("input:radio[name=activityGroup][value=MCSS]").attr('checked', 'checked');
	$("#questionInput").val("");
	$("#instructionInput").val("");
	selectedTab = 0;
	//$("#optionContainer .option").val("");
};
this.deleteCurrentActivity = function(){
	activityCollection.splice(selectedTab,1);
	$(".tabs").find("li:eq("+selectedTab+")").remove();
	selectedTab -= 1; 
	activity = new Array();
	activity = activityCollection[selectedTab];
	renderActivityData(activity);
};
this.showSolution = function(event){
	try{
		var $target	= $(event.target).closest('div.activity').find('li div.optionContainer');
		var solution = [];
		$target.find('li').each(function(){
			if($(this).find('input[name="option"]').attr('data-answer-state') == "true")
				{
					solution.push($(this));
					$(this).toggleClass('activitySolution');
				}
				
		});
	}
	catch (e){
		console.log('error');
	}
};
this.submitSolution = function(event){
	var $target;
	var rightChoice = [],
		wrongChoice = [];
	try{
		$target	= $(event.target).closest('div.activity').find('li div.optionContainer');
		$target.find('li').each(function(){
			if($(this).find('input[name="option"]').is(':checked')){
				if($(this).find('input[name="option"]').attr('data-answer-state') == "true")
					rightChoice.push($(this));
				else
					wrongChoice.push($(this));
			}
		});
		if(rightChoice.length == 0)
			alert('Wrong answer..!!');
		else if(rightChoice.length == $target.find('li input[name="option"][data-answer-state="true"]').length)
			alert('Success..!!');
		else
			alert("You selected "+rightChoice.length+" correct options..!!"); 
	}
	catch (e){
		console.log('error');
	}
};

window.onload = function () {
	if(!document.body.className.match("cke_editable")){
		var btnArray = document.body.getElementsByClassName('deleteActivityBtnCK');
		for(var i=0; i< btnArray.length; i++)
			btnArray[i].style.display='none';
		btnArray = document.body.getElementsByClassName('editActivityBtnCK');
		for(var i=0; i< btnArray.length; i++)
			btnArray[i].style.display='none';
	}
}

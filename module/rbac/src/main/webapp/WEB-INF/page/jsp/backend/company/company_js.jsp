<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>

<script type="text/javascript">
(function(){
	var company = {};
	
	// 获取访问地址
	getRealPath = function(path){
		var basePath = '<s:url value="/rbac/backend/company/" />';
		return basePath + path;
	};
   
    // 添加组织机构
	$('body').on('click', '.add', function(){

		var addTargetId = "#addForm";
		
		// 数据提交（添加保存）
		var submit = function(){
			
	    	// 成功回调
			var success = function(data){
				msgAlert(data);
				refresh();
			}
	    	
			var options = ajaxOption(getRealPath("add"),success);
			$(addTargetId).ajaxSubmit(options);
		};
		
		// 请求添加html页面
		var success = function(html){
	    	layer.open({
	    		title: '添加组织机构',
	    		area:["800px"],
	    		content: html,
	    		btn: ['添加', '关闭'],
	    		yes:function(index, layer){
	    			// 校验数据成功后提交
	    			validate($(addTargetId),submit);
	    		},
	    		success:function(){
	    	    	// 绑定页面校验
	    	    	bindValidate($(addTargetId));
	    		}
	    	});
		};
		
		// 数据请求
		ajaxHtml(getRealPath("add"),{},success);
	 });

    // 删除组织机构
	$('body').on('click', '.delete', function(){
    	// 获取所有选中的ids
    	var ids = getSelections("company_checkbox","company_id");

    	if(ids!="") {
			// 删除确认
			layer.confirm('确定要删除么？', {
				  btn: ['确定','关闭']
				}, function(){
			    	// 成功回调
					var success = function(data){
			    		msgAlert(data);
						refresh();
					}
					var data = {"ids":ids};
					ajaxJson(getRealPath("batchDelete"), data, success);
			});
    	} else {
    		layer.alert("请选择要删除的数据！");
    	}
	 });
    
    // 组织机构排序
    $('body').on('click', '.sort', function(){
		// 成功回调
		var success = function(html){
	    	layer.open({
	    		title: '组织机构排序',
				btn: ['保存','关闭'],
	    		area:["828px"],
			    content: html,
			    yes: function(){
			    	var ids = $("[name=company_sort_id]");
			    	
			    	var data = "";
			    	ids.each(function(){
			    		if(data == "") {
			    			data = $(this).val();
			    		} else {
			    			data += "," + $(this).val();
			    		}
			    	});
			    	
			    	// 成功提示
			    	var success = function(data){
			    		msgAlert(data);
			    		refresh();
			    	};
			    	
					// 数据提交
					ajaxJson(getRealPath("sort"),{"ids":data},success);
			    }
	    	});
		};
		
		// 查询条件
		var searchData = {"companyId" : companyTree.getCurrentId()};
		// 数据请求
		ajaxHtml(getRealPath("sortList"),searchData,success);
    });

	// 列表显示
	company.companyList = function(companyId){
		if(companyId != undefined){
			// 查询条件
			var searchData = {"companyId" : companyId};
			
			// 成功回调
			var success = function(html){
				$("#companyListTd").html(html);
			};
			
			// 数据请求
			ajaxHtml(getRealPath("list"),searchData,success);
		}
	};
	
	// 根节点列表显示
	company.rootCompanyList = function(type){
		// 查询条件
		var searchData = {"type" : type, "companyId" : "0"};
		
		// 成功回调
		var success = function(html){
			$("#companyListTd").html(html);
		};
		
		// 数据请求
		ajaxHtml(getRealPath("list"),searchData,success);
	};
	
    // 查看组织机构
    company.detail = function(id){
    	// 请求数据
    	var data = {"id":id};
    	
    	// 成功回调函数
    	var success = function(html){
	    	layer.open({
	    		title: '查看组织机构',
	    		area:["800px"],
	    		content: html,
	    		btn: ['关闭']
	    	});
		};
		
		ajaxHtml(getRealPath("detail"),data,success);
    };
    
    // 删除组织机构
    company.deleteSingle = function(id){
    	var data = {"id":id};
		// 成功回调
    	var success = function(data){
    		msgAlert(data);
   			refresh();
		};
		
		// 删除确认
		layer.confirm('确定要删除么？', {
			  btn: ['确定','关闭']
			}, function(){
				ajaxJson(getRealPath("delete"), data, success);
		});
    };
    
    // 选中当前行
    company.selectCurrent = function(event){
    	// 选中当前的
    	var radio = $(event.target).parent().find(":radio");
    	radio.prop("checked",true);
    };
    
    // 排序组织机构
    company.sortByFlag = function(flag){
    	// 取消之前选中的
    	var radioSelected = getSelectedRadio("company_sort_radio");
   		var tr = $(radioSelected).parent().parent();
   		if(radioSelected == null) {
   			parent.layer.alert("请选中要排序的行！");
   			return;
   		}
   		// 上移
   		if(flag==0) {
       		var prev = tr.prev();
       		if(prev.length==1) {
       			prev.before(tr);
       		} else {
       			parent.layer.alert("已到达最顶部，无法再移动！");
       		}
   		} else {
   			// 下移
       		var next = tr.next();
       		if(next.length==1) {
       			next.after(tr);
       		} else {
       			parent.layer.alert("已到达最底部，无法再移动！");
       		}
   		}
    };
    
    // 修改组织机构
    company.update = function(id){

		var success = function(html){
			var targetId = "#updateForm";
			// 提交数据
			var submit = function(){
    			var options = ajaxOption(getRealPath("update"),function(data){
    				msgAlert(data);
    				refresh();
    			});
    			$(targetId).ajaxSubmit(options);
			};
			
	    	layer.open({
	    		title: '修改组织机构',
	    		area: ["800px"],
	    		content: html,
	    		btn: ['修改', '关闭'],
	    		yes: function(index, layer){
	    			validate($(targetId),submit);
	    		},
	    		success: function(){
	    	    	// 页面校验
	    	    	bindValidate($(targetId));
	    		}
	    	});
		};
		
		// 请求明细数据
		var data = {"id":id};
		ajaxHtml(getRealPath("update"),data,success);
    };
    
    // 刷新界面
    refresh = function(){
		var success = function(data){
			// 刷新组织机构树
			var treeObj = companyTree.init("ztree1", eval(data));
			
			// 更新当前节点
			companyTree.selectCurrent("ztree1");
		};
		
    	ajaxText(getRealPath("getTree"),{},success);
    };
    
    $(document).ready(function(){
    	refresh();
    });
    
    window['company'] = company;
})();
</script>

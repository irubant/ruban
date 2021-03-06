<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>

<script type="text/javascript">
(function(){
	var person = {};
	
	// 获取访问地址
	getRealPath = function(path){
		var basePath = '<s:url value="/rbac/backend/person/" />';
		return basePath + path;
	};
    
    // 删除图片,设置图片为删除状态
    deletePhoto = function(photoId){
    	$("#" + photoId + "_del").val("1");
    	$("#" + photoId + "_img").attr("src","");
    	$("#" + photoId + "_btn").hide();
    };
    
    // 刷新界面
    refresh = function(){
		var success = function(data){
			// 刷新组织机构树
			var treeObj = dptTree.init("dptTree", eval(data));
			
			// 更新当前节点
			dptTree.selectCurrent("dptTree");
		};
		
    	ajaxText(getRealPath("getDptTree"),{},success);
    };
    
    // 组织机构树列表查询
    person.objectList = function(companyId){
    	personList(companyId);
    };
    
	// 查询人员列表
	personList = function(departmentId){
		if(departmentId == undefined){
			departmentId = '0';
		}
		// 查询条件
		var searchData = {"departmentId" : departmentId};
		
		// 成功回调
		var success = function(html){
			$("#personListTd").html(html);
		};
		
		// 数据请求
		ajaxHtml(getRealPath("search"),searchData,success);
	};
	
    $('body').on('click', '.add', function(){
    	
    	var targetId = "#person_add_form";
    	
		// 数据提交
		var submit = function(){
			
	    	// 成功回调
			var success = function(data){
				msgAlert(data);
				refresh();
			}
	    	
			var options = ajaxOption(getRealPath("add"),success);
			$(targetId).ajaxSubmit(options);
		};
		
		var success = function(html){
	    	layer.open({
	    		title: '添加人员',
	    		area:['1250px'],
	    		content: html,
	    		btn:['添加', '关闭'],
	    		yes:function(index, layer){
	    			// 校验数据成功后提交
	    			validate($(targetId),submit);
	    		},
	    		success:function(){
	    	    	// 绑定页面校验
	    	    	bindValidate($(targetId));

	    	    	$(targetId + "_photo").change(function(){
	    	    		var imgSrc = URL.createObjectURL($(this)[0].files[0]);
	    	    		$(targetId + "_photo_img").attr("src", imgSrc);
	    	    		$(targetId + "_photo_btn").show();
	    	    		$(targetId + "_photo_del").val("0");
	    	    	});
	    		}
	    	});
		};
    	
		// 数据请求
		ajaxHybrid(getRealPath("add"),{},success);
    });
    
    // 人员排序
    $('body').on('click', '.sort', function(){
		// 成功回调
		var success = function(html){
	    	layer.open({
	    		title: '人员排序',
				btn: ['保存','关闭'],
	    		area:["828px"],
			    content: html,
			    yes: function(){
			    	var ids = $("[name=person_sort_id]");
			    	
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
		var searchData = {"departmentId" : dptTree.getCurrentId()};
		// 数据请求
		ajaxHtml(getRealPath("sortList"),searchData,success);
    });
    // 删除人员
	$('body').on('click', '.delete', function(){
    	// 获取所有选中的ids
    	var ids = getSelections("person_checkbox","person_id");

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
    
    $('body').on('click', '.search', function(){
    	person.search();
    });
    
    // 查询
    person.search = function(){

		// 成功回调
		var success = function(html){
			$("#personListTd").html(html);
		};
    	
		
		var options = ajaxOptionHtml(getRealPath("search"), success);
		// 添加分页数据
		addAjaxData(options,pagination.getPageData());
		
		$("#searchForm").ajaxSubmit(options);
    };
    
    // 修改人员信息
    person.update = function(id){

		var success = function(html){
			
			var target_id = "#person_update_form";
			
			// 提交数据
			var submit = function(){
    			var options = ajaxOption(getRealPath("update"),function(data){
    				msgAlert(data);
    				refresh();
    			});
    			$(target_id).ajaxSubmit(options);
			};

	    	layer.open({
	    		title: '修改人员信息',
	    		area: ["1150px"],
	    		content: html,
	    		btn: ['修改', '关闭'],
	    		yes: function(index, layer){
	    			validate($(target_id),submit);
	    		},
	    		success: function(){
	    	    	// 页面校验
	    	    	bindValidate($(target_id));
	    	    	
	    	    	$(target_id + "_photo").change(function(){
	    	    		var imgSrc = URL.createObjectURL($(this)[0].files[0]);
	    	    		$(target_id + "_photo_img").attr("src", imgSrc);
	    	    		$(target_id + "_photo_btn").show();
	    	    		$(target_id + "_photo_del").val("0");
	    	    	});
	    		}
	    	});
		};
		
		// 请求明细数据
		var data = {"id":id};
		
		// 数据请求
		ajaxHybrid(getRealPath("update"),data,success);
    };
    
    // 查看部门
    person.detail = function(id){
    	
    	// 成功回调函数
    	var success = function(data){
    		
    		if(data.flag == '0') {
    			layer.alert("无结果");
    		} else {
		    	layer.open({
		    		title: '查看人员',
		    		area:["1150px"],
		    		content: data,
		    		btn: ['关闭']
		    	});
    		}
		};
		
    	// 请求数据
    	var data = {"id":id};
		ajaxHybrid(getRealPath("detail"),data,success);
    };
    
    
    // 删除人员
    person.deleteSingle = function(id){
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
    
	$(document).ready(function(){
		refresh();
	});
    
    window['person'] = person;
})();
</script>

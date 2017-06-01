(function() {
	var user = {};

	// 获取访问地址
	getRealPath = function(path) {
		return bizURL.user + path;
	};

	// 账号添加
	user.add = function() {

		var targetId = "#user_add_form";

		// 数据提交
		var submit = function() {

			// 成功回调
			var success = function(data) {
				msgAlert(data);
				// 更新数据
				user.search();
			}

			var options = ajaxOption(getRealPath("addSave"), success);
			$(targetId).ajaxSubmit(options);
		};

		var success = function(html) {
			layer.open({
				title : '添加账号',
				area : [ '750px' ],
				content : html,
				btn : [ '添加', '关闭' ],
				yes : function(index, layer) {
					// 校验数据成功后提交
					validate($(targetId), submit);
				},
				success : function() {
					// 绑定页面校验
					bindValidate($(targetId));
				}
			});
		};

		// 数据请求
		ajaxHybrid(getRealPath("addPage"), {}, success);
	};

	// 用户账号排序
	user.sort = function() {
		// 成功回调
		var success = function(html) {
			layer.open({
				title : '用户排序',
				btn : [ '保存', '关闭' ],
				area : [ "828px" ],
				content : html,
				yes : function() {
					var ids = $("[name=user_sort_id]");

					var data = "";
					ids.each(function() {
						if (data == "") {
							data = $(this).val();
						} else {
							data += "," + $(this).val();
						}
					});

					// 成功提示
					var success = function(data) {
						msgAlert(data);
					};

					// 数据提交
					ajaxJson(getRealPath("sort"), {
						"ids" : data
					}, success);
				}
			});
		};

		// 查询条件
		var searchData = {
			"departmentId" : dptTree.getCurrentId()
		};
		
		// 数据请求
		ajaxHtml(getRealPath("sortList"), searchData, success);
	};

	// 删除用户
	user.batchDelete = function() {
		// 获取所有选中的ids
		var ids = getSelections("user_checkbox", "user_id");

		if (ids != "") {
			// 删除确认
			layer.confirm('确定要删除么？', {
				btn : [ '确定', '关闭' ]
			}, function() {
				// 成功回调
				var success = function(data) {
					msgAlert(data);
					// 更新数据
					user.search();
				}
				var data = {
					"ids" : ids
				};
				ajaxJson(getRealPath("batchDelete"), data, success);
			});
		} else {
			layer.alert("请选择要删除的数据！");
		}
	};

	// 查询
	user.search = function() {

		// 成功回调
		var success = function(html) {
			$("#userListTd").html(html);
		};

		var options = ajaxOptionHtml(getRealPath("search"), success);
		// 添加分页数据
		addAjaxData(options, pagination.getPageData());

		$("#searchForm").ajaxSubmit(options);
	};

	// 修改用户信息
	user.update = function(id) {

		var success = function(html) {

			var target_id = "#user_update_form";

			// 提交数据
			var submit = function() {
				var options = ajaxOption(getRealPath("updateSave"), function(data) {
					msgAlert(data);
					// 更新数据
					user.search();
				});
				$(target_id).ajaxSubmit(options);
			};

			layer.open({
				title : '修改账号',
				area : [ "750px" ],
				content : html,
				btn : [ '修改', '关闭' ],
				yes : function(index, layer) {
					validate($(target_id), submit);
				},
				success : function() {
					// 页面校验
					bindValidate($(target_id));
				}
			});
		};

		// 请求明细数据
		var data = {
			"id" : id
		};

		// 数据请求
		ajaxHybrid(getRealPath("updatePage"), data, success);
	};

	// 查看部门
	user.detail = function(id) {

		// 成功回调函数
		var success = function(data) {

			if (data.flag == '0') {
				layer.alert("无结果");
			} else {
				layer.open({
					title : '查看用户',
					area : [ "800px" ],
					content : data,
					btn : [ '关闭' ]
				});
			}
		};

		// 请求数据
		var data = {
			"id" : id
		};
		ajaxHybrid(getRealPath("detail"), data, success);
	};

	// 删除用户
	user.deleteSingle = function(id) {
		var data = {
			"id" : id
		};
		// 成功回调
		var success = function(data) {
			msgAlert(data);
			// 更新数据
			user.search();
		};

		// 删除确认
		layer.confirm('确定要删除么？', {
			btn : [ '确定', '关闭' ]
		}, function() {
			ajaxJson(getRealPath("delete"), data, success);
		});
	};

	window['user'] = user;
})();

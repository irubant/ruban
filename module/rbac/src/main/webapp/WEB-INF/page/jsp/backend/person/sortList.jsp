<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="button-group">
   <div class="button" onclick="sortByFlag(0, 'person_sort_radio')">
       <i class="iconfont">&#xe617;</i>
       <span class="button-label">上移</span>
   </div>
   <div class="button" onclick="sortByFlag(1, 'person_sort_radio')">
       <i class="iconfont">&#xe629;</i>
       <span class="button-label">下移</span>
    </div>
</div>
<table class="grid">
	<thead>
		<tr>
			<th class="grid-checkbox"><input type="checkbox"></th>
			<th>所属组织机构</th>
			<th>所属部门</th>
			<th>姓名</th>
			<th>姓别</th>
			<th>职务</th>
			<th>岗位</th>
		</tr>
	</thead>
	
	<tbody>
		<c:forEach items="${resultInfo.list}" var="result">
			<tr ondblclick="person.detail('${result.id}');">
					<td class="grid-checkbox">
						<input type="radio" name="person_sort_radio" />
						<input type="hidden" name="person_sort_id" value="${result.id}"/>
					</td>
				<td>${result.companyName}</td>
				<td>${result.departmentName}</td>
				<td>${result.name}</td>
				<td>${result.titleName}</td>
				<td>${result.sex}</td>
				<td>${result.jobName}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
<jsp:include page="/WEB-INF/page/jsp/pagination.jsp">
	<jsp:param value="person.search" name="action"/>
</jsp:include>
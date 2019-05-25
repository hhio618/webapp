<content:title>
    <fmt:message key="app.categories" /> (${fn:length(project.appCategories)})
</content:title>

<content:section cssId="appCategoryListPage">
    <div class="section row" style="padding-right: 2em;">
        <p>
            <fmt:message key="to.add.new.content.click.the.button.below" />
        </p>
        
        <c:forEach var="appCategory" items="${project.appCategories}">
            <div class="col s12 card-panel appCategory" data-id="${appCategory.id}" 
                    style="padding: 1em;" 
                    draggable="true"
                    ondragstart="drag(event)"
                    ondragover="allowDrop(event)"
                    ondragleave="cancelDrop(event)"
                    ondrop="drop(event)">
                
                <a class="editLink right" href="<spring:url value='/project/${project.id}/app-category/edit/${appCategory.id}' />"><span class="material-icons" style="vertical-align: bottom;">edit</span> <fmt:message key="edit" /></a>
                
                <a href="<spring:url value='/project/${project.id}/app-category/${appCategory.id}/app-group/list' />">
                    <h5><c:out value="${appCategory.name}" /></h5>
                </a>
                
                <c:if test="${not empty appCategory.backgroundColor}">
                    <div class="divider" 
                         style="background-color: rgb(${appCategory.backgroundColor}); height: 1em; margin-right: -1em; margin-left: -1em;">
                    </div>
                </c:if>
                
                <%-- List AppGroups --%>
                <c:forEach var="appGroup" items="${appCategory.appGroups}">
                    <br />
            <c:choose>
                <c:when test="${not empty appCategory.backgroundColor}">
                    <div style="padding: 1em; background-color: rgba(${appCategory.backgroundColor}, 0.2);">
                </c:when>
                <c:otherwise>
                    <div style="padding: 1em; background-color: #FAFAFA;">
                </c:otherwise>
            </c:choose>
                        <%-- List Applications --%>
                        <c:forEach var="application" items="${appGroup.applications}">
                            <a href="<spring:url value='/project/${project.id}/app-category/${appCategory.id}/app-group/${appGroup.id}/app/${application.id}/edit' />" title="${application.packageName}">
                                ${application.packageName}
                            </a>&nbsp;
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>
        </c:forEach>
        <script>
            function drag(event) {
                console.info("drag");
                
                var $target = $(event.target);
                $target.addClass("dragStarted");
            };
            
            function allowDrop(event) {
                console.info("allowDrop");
                
                event.preventDefault();
                
                var $target = $(event.target);
                $target.addClass("dragOver");
            };
            
            function cancelDrop(event) {
                console.info("cancelDrop");
                
                event.preventDefault();
                
                var $target = $(event.target);
                $target.removeClass("dragOver");
            };
            
            function drop(event) {
                console.info("drop");
                
                event.preventDefault();
                
                var appCategoryArray = "[";
                $(".appCategory").each(function(index) {
                    console.info("index: " + index);
                    var id = $(this).attr("data-id");
                    appCategoryArray += id;
                    if (index < ($(".appCategory").length - 1)) {
                        appCategoryArray += ",";
                    }
                });
                appCategoryArray += "]";
                console.info("appCategoryArray " + appCategoryArray);
                $.ajax({
                  type: "POST",
                  url: "<spring:url value='/project/1/app-category/list' />",
                  data: {
                      appCategoryArray: appCategoryArray
                  }
                });
            }
        </script>
    </div>
    
    <div class="fixed-action-btn" style="bottom: 2em; right: 2em;">
        <a href="<spring:url value='/project/${project.id}/app-category/create' />" class="btn-floating btn-large tooltipped" data-position="left" data-delay="50" data-tooltip="<fmt:message key="add.app.category" />"><i class="material-icons">add</i></a>
    </div>
</content:section>

<c:if test="${not empty project.appCategories}">
    <content:aside>
        <h5 class="center"><fmt:message key="app.collections" /></h5>

        <table class="bordered highlight">
            <thead>
                <th><fmt:message key="name" /></th>
                <th><fmt:message key="app.categories" /></th>
            </thead>
            <tbody>
                <c:forEach var="appCollection" items="${appCollections}">
                    <tr class="appCollection">
                        <td>
                            <a href="<spring:url value='/project/${project.id}/app-collection/edit/${appCollection.id}' />">
                                <c:out value="${appCollection.name}" />
                            </a>
                        </td>
                        <td>
                            ${fn:length(appCollection.appCategories)}
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <p></p>

        <a href="<spring:url value='/project/${project.id}/app-collection/create' />" class="btn waves-effect waves-grey grey-text">
            <fmt:message key="add.app.collection" />
        </a>
    </content:aside>
</c:if>

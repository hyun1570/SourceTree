<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page extends="com.cni.fw.arch.ArchJsp"%>
<%@ page import="com.cni.fw.ff.dto.*"%>
<%@ page import="com.cni.fw.ff.dto.entity.*"%>
<%@ page import="com.cni.fw.ff.util.maker.*"%>
<%@ page import="com.cni.fw.ff.dto.support.*"%>
<%@ page import="com.cni.fw.ff.util.*"%>
<%@ page import="com.cni.fw.id.*"%>
<%@ page import="com.cni.fw.web.util.*"%>
<%@ page import="com.cni.fw.ff.conf.*"%>
<%@ page import="com.cni.fw.web.session.so.CommonSession"%>
<%@ page import="com.ddsm.base.menu.pageSupport"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
   String _btnGroups = "";

   //기본 버튼 ID 지정
    String[] _btnToInclude = { "add", "delete", "check","search","excel","attach","download" };
    
    CauseDTO input = getCauseDTO(request);
    EffectDTO output = getEffectDTO(request);
    CommonSession cs = null;
       
    if (input != null) {
        cs = input.getCommonSession();
    }
    
    pageSupport _mm = new pageSupport(this.getClass());
    
    _mm.setCurrent(request.getParameter("current"));
    
    _mm.setParameters(request.getParameter("param")==null?"":request.getParameter("param"));
    
    _mm.set_command(input.getCommand().getCommand());
    
    _mm.set_cs(cs);
    
    String _menu = _mm.getTemplate(input);
    
    if (_menu ==null ) _menu = "<div class=space30 ><ul class=main_nav style='height:30px;vertical-align:middle;text-align:center;padding-top: 10px;color:white'><li>등록된 메뉴가 없습니다.</li></ul></div>";
    
   // pageContext.setAttribute("TOP_MENU",_menu);
    
    //pageContext.setAttribute("PAGE_TITLE", _mm.getPageTitle());
    
    //pageContext.setAttribute("MENU_NAME",_mm.getMenuName());
    
    //pageContext.setAttribute("GRANT",_mm.getGrant());
    
    //if (request.getParameter("current") != null)
//      pageContext.setAttribute("GRIDLIST2",_mm.getGridList());
    pageContext.setAttribute("DIC",_mm.getDic());

    if (!"".equals(_mm.getGrant()) && _mm.getGrant()!="null" && _mm.getGrant()!=null)
    {
        String[]  _ar =  _mm.getGrant().split("\\,");
               
        //버튼셋을 내려준다.
        for (int j=0; j<_ar.length;j++)
        {
            String[]  _bt = _ar[j].split("\\|");
            //기본 버튼셋에 없을경우 CSS를 gray로 지정 
            if (Arrays.asList(_btnToInclude).contains(_bt[1]))
                  _btnGroups +="<a class='btn_"+_bt[1]+"' href='javascript:void(0);' id='btn_"+_bt[1]+"'><span class='btn_"+_bt[1]+"_left'>"+_bt[0]+"</span></a> ";
            else
                _btnGroups +="<a class='btn_gray' href='javascript:void(0);' id='btn_"+_bt[1]+"'><span class='btn_gray_left'>"+_bt[0]+"</span></a> ";
        }

    }
    
    //폼 엘러먼트에 값을 채워준다.
    if (request.getParameter("param")!= null)
    {
        LTO resList = _mm.getListOfElements();
        
        if (resList!=null)
        {
            MTO _k = resList.get(0);
            //MTO객체의 Key를 배열로
            Object[] _ar =  _k.keySet().toArray();
            
            for(int i =0; i<resList.size();i++)
            {
                //쿼리 결과 리턴
                for (int j=0; j<_ar.length;j++)
                {
                    pageContext.setAttribute(_ar[j].toString(), _k.get(_ar[j].toString()));
                }                
            }
        }
    }
%> 

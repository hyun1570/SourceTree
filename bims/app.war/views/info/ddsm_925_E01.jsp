<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ include file="/views/include/tag_lib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>:::::::::::: <%=_mm.getPageTitle() %> ::::::::::::</title>
<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>

<script language="javascript">

var mainGrid;
var mainProvider;
var secondGrid;
var secondProvider;
var thirdGrid;
var thirdProvider;
var fourthGrid;
var fourthProvider;

//초기화
$(window).load(function(){
        
    setGridObject("grdMain", "100%", "100%");    
    setGridObject("grdMain2", "100%", "100%");
    setGridObject("grdMain3", "100%", "100%");
    setGridObject("grdMain4", "100%", "100%");
});

function setGridObject(tagid, width, height, onload)
{
    var flashvars = { id: tagid };

    if (onload && typeof(onload) === "function")
    {
        flashvars.onload = onload;        
    }

    var params = {};
    params.quality = "high";
    params.wmode = "opaque";
    params.allowscriptaccess = "always";
    params.allowfullscreen = "true";

    var attributes = {};
    attributes.id = tagid;
    attributes.name = tagid;
    attributes.align = "middle";
    
    /* SWFObject v2.2 <http://code.google.com/p/swfobject/> */
    var swfUrl = "<%=request.getContextPath()%>/resources/objects/RealGridWeb.swf";
    swfobject.embedSWF(swfUrl, tagid, width, height, "11.1.0", "<%=request.getContextPath()%>/resources/objects/expressInstall.swf", flashvars, params, attributes);    
};

RealGrids.onload = function (id,r)
{
    if (id=="grdMain")
    {
        mainGrid     = new RealGrids.GridView(id);
        mainProvider = new RealGrids.LocalDataProvider();
        
        mainGrid.setStyles(_grid_style);
        
        mainGrid.setDataProvider(mainProvider);
        
        setColumns(mainProvider, mainGrid);
        setOptions(mainGrid);     
        
        mainGrid.onDataCellClicked = function (grid, index) {            
            var row = index.dataRow;
            mainGrid.checkAll(false);
            mainGrid.checkRow(row, true, false);         
        };
    } else if (id=="grdMain2") {
        secondGrid     = new RealGrids.GridView(id);
        secondProvider = new RealGrids.LocalDataProvider();
        
        secondGrid.setStyles(_grid_style);
        
        secondGrid.setDataProvider(secondProvider);
        
        setSecondFields(secondProvider);
        setSecondColumns(secondGrid);
        setSecondOptions(secondGrid);
        
        secondGrid.onDataCellClicked = function (grid, index) {            
            var row = index.dataRow;
            secondGrid.checkAll(false);
            secondGrid.checkRow(row, true, false);
        };
    } else if (id=="grdMain3") {
        thirdGrid     = new RealGrids.GridView(id);
        thirdProvider = new RealGrids.LocalDataProvider();
        
        thirdGrid.setStyles(_grid_style);
        
        thirdGrid.setDataProvider(thirdProvider);
        
        setThirdFields(thirdProvider);
        setThirdColumns(thirdGrid);
        setThirdOptions(thirdGrid);
        
        thirdGrid.onDataCellClicked = function (grid, index) {            
            var row = index.dataRow;
            thirdGrid.checkAll(false);
            thirdGrid.checkRow(row, true, false); 
        };
    } else if (id=="grdMain4") {
    	fourthGrid     = new RealGrids.GridView(id);
    	fourthProvider = new RealGrids.LocalDataProvider();
        
    	fourthGrid.setStyles(_grid_style);
        
    	fourthGrid.setDataProvider(fourthProvider);
        
        setFourthFields(fourthProvider);
        setFourthColumns(fourthGrid);
        setFourthOptions(fourthGrid);
        
        fourthGrid.onDataCellClicked = function (grid, index) {            
            var row = index.dataRow;
            fourthGrid.checkAll(false);
            fourthGrid.checkRow(row, true, false); 
        };
    }
};

function setColumns(provider,grid)
{
    var c = []; 
    
    var iconStyles = [
        {
            "criteria": "value='N'",
            "styles": "iconIndex=7"
        },
        {
            "criteria": "value='Y'",
            "styles": "iconIndex=0"
        },
        {
            "criteria": "value=''",
            "styles": "iconIndex=1"
        }
    ];
    
    var g = JSON.parse(_gridList);

    for (var i=0; i<g.length; i++)
    {
        var obj = {};
        obj.fieldName = g[i].a.mappingId;
        obj.width     = g[i].a.width;
        obj.height    = g[i].a.height;
        obj.header    = {text : g[i].a.headerText};
        obj.styles    = {textAlignment : g[i].a.align};            // 그리드 정렬
        obj.visible   = g[i].a.visible == "Y" ? true : false;     // 그리드 Visible
        obj.readOnly  = g[i].a.columnType == "ro" ? true : false; // 그리드 Edit Mode
        //obj.editable  = !obj.readOnly                            // 그리드 Edit Mode
        //obj.editable  = false;
        
        //콤보박스 설정
        if (g[i].a.columnType=="dropDown")
        {   
            //TypeValue에 지정한  Common Master Code에 해당하는 공통코드를 콤보로 가져온다
            var _t = getCommonCodeToGridCombo(g[i].a.typeValue);
            
            obj.lookupDisplay = true;
            obj.values = _t.values;
            obj.labels = _t.labels,
            obj.editor = {type : _t.type}; //, dropDownCount : _t.dropDownCount
        }
        else if (g[i].a.columnType == "ch")
        {
            obj.editable = false;
            obj.renderer = {
                 type: "check",
                 editable: true,
                 startEditOnClick: true,
                 trueValues: "Y",
                 falseValues: "N",
                 labelPosition: "hidden"
             }
        }
        else if (g[i].a.columnType == "im")
        {
            obj.imageList =  "images1";
            obj.renderer = {
                            "type"             : "icon",
                            "editable"         : false,
                            "startEditOnClick" : false
            },
            obj.dynamicStyles = iconStyles,
            obj.styles = {
                "textAlignment" : "center",
                "iconLocation"  : "bottom",
                "iconAlignment" : "center",
                "contentFit"    : "center", 
                "iconOffset"    : 2,
                "iconPadding"   : 1,
                "fontSize"      : 0,
                "foreground"    : "#FFFFFF"
            },
            obj.editable = false;
        } else if(g[i].a.columnType == "dt" || g[i].a.columnType == "rodt"){
            obj.dataType = "datetime";
            obj.datetimeFormat = "yyyyMMdd";
            obj.styles = {"textAlignment" : g[i].a.align,
                    "datetimeFormat" : "yyyy-MM-dd"};
            obj.editor = {"datetimeFormat" : "yyyyMMdd"};
            if(g[i].a.columnType == "rodt"){
                obj.readOnly = true;
            }
        } else if(g[i].a.columnType == "no" || g[i].a.columnType == "rono"){
            obj.dataType = "numeric";
            obj.styles={
                     "textAlignment": "far",
                     "numberFormat": "#,###"
            };
            obj.editor = {"type":"number", maxLength : g[i].a.maxLength=='undefined'?300:g[i].a.maxLength, positiveOnly:true, integerOnly:true};
            
            if(g[i].a.columnType == "rono"){
                obj.readOnly = true;
            }
        }
        else 
        {
            //셀의 Max 값을 지정
            obj.editor = {type : "line", maxLength : g[i].a.maxLength=='undefined'?300:g[i].a.maxLength}
        }
        
        c.push(obj);
    }
     
    //Field Id를 그리드에 정의 한다.
    if (provider == mainProvider) {
        provider.setFields(c);
    }
    
    //그리드에 컬럼셋을 설정한다.
    if (grid == mainGrid)
    {
        grid.setColumns(c);
    }
    //If there's more grid then add else if code
}

function getCommonCodeToGridCombo(_masterCode)
{
     //조회 파라메터 Object
     var jsonObj = {
             sqlid      : 'CommonCode.ddsm_190_L02',
             masterCode : _masterCode,
             siteCode   : '${SESSION_SITE_CODE}'
     };
    
     //Return Object(Realgrid Combo)
     var ret  = {
             type   : 'dropDown', 
             values : [], 
             labels : []  
     };
     
     $.ajax({
         type      : "POST",
         url       : "/bims/DDSM.BASE.SERVICE.R00.cmd?param="+JSON.stringify(jsonObj),
         dataType  : "json",
         data      : {"param" : JSON.stringify(jsonObj)},
         async     : false,
         beforeSend: function(xhr)
         {
             
         },
         success   : function(r)
         {
             ret.dropDownCount = r.length;
             
             for (i in r)
             {
                 ret.values.push(r[i].code);
                 ret.labels.push(r[i].codeName);
                     
             }
         },
         error     : function()
         {
             // Error 발생 Code
         }
     });
     
     return ret;
}

//그리드 Option 설정
function setOptions(grid)
{
  grid.setOptions(
  {
      panel :
      {
          visible : false
      },
      footer :
      {
          visible : false
      },
      checkBar :
      {
          visible : false,
          exclusive : true
      },
      statusBar :
      {
          visible : false
      },
      edit :
      {
          insertable : true,
          appendable : true,
          updatable  : true,
          deletable  : true,
          deleteRowsConfirm : true,
          deleteRowsMessage : "Are you sure?"
      }
  });
}

//그리드 Data 필드 설정 
function setSecondFields(provider)
{
    var fields = [
                  {fieldName : "setSeq"},
                  {fieldName : "MTART"},
                  {fieldName : "LGORT"},
                  {fieldName : "ZMATKL"},
                  {fieldName : "KTGRM"},
                  {fieldName : "MTPOS"},
                  {fieldName : "DISMM"},                  
                  {fieldName : "DISLS"},
                  {fieldName : "BESKZ"},
                  {fieldName : "FHORI"},
                  {fieldName : "SBDKZ"},
                  {fieldName : "BKLAS"},
                  {fieldName : "MLAST"},
                  {fieldName : "PEINH"},
                  {fieldName : "HKMAT"},
                  {fieldName : "PRCTR"},
                  {fieldName : "VPRSV"},
                  {fieldName : "useYn"},
                  {fieldName : "regId"},
                  {fieldName : "regDateTime"},
                  {fieldName : "modId"},
                  {fieldName : "modDateTime"}
               ];

    // Field Id를 그리드에 정의 한다.
    if (provider == secondProvider)
    {
        provider.setFields(fields);
    }
}

//그리드 Data 필드 설정 
function setThirdFields(provider)
{
    var fields = [
                  {fieldName : "setSeq"},
                  {fieldName : "VTWEG"},                  
                  {fieldName : "useYn"},
                  {fieldName : "regId"},
                  {fieldName : "regDateTime"},
                  {fieldName : "modId"},
                  {fieldName : "modDateTime"}
               ];

    // Field Id를 그리드에 정의 한다.
    if (provider == thirdProvider)
    {
        provider.setFields(fields);
    }
}

//그리드 Data 필드 설정 
function setFourthFields(provider)
{
    var fields = [
                  {fieldName : "setSeq"},
                  {fieldName : "WERKS"},
                  {fieldName : "VABME"},
                  {fieldName : "KORDB"},
                  {fieldName : "DISPO"},
                  {fieldName : "MATKL"},
                  {fieldName : "useYn"},
                  {fieldName : "regId"},
                  {fieldName : "regDateTime"},
                  {fieldName : "modId"},
                  {fieldName : "modDateTime"}
               ];

    // Field Id를 그리드에 정의 한다.
    if (provider == fourthProvider)
    {
        provider.setFields(fields);
    }
}

//그리드 컬럼 Setting
function setSecondColumns(grid)
{
    var columns = [
                   {
                       fieldName : "setSeq",
                       width     : 0,
                       header    : { text: "SEQ" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true,                       
                   },
                   {
                       fieldName : "ZMATKL",
                       width     : 110,
                       header    : { text: "자재구분그룹" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true,
                       editor    : {type : "dropDown"},
                       values    : ["HE02","HL02","HEZ2","HLZ2","HE01","HL01","UW02","UW03","UW04","UW05"],
                       labels    : ["설비(수출)","설비(내수)","금형(수출)","금형(내수)","Gift(수출)","Gift(내수)","Mock-Up","진열대","폐가전","Pallet"],
                       lookupDisplay : true
                   },                   
                   {
                       fieldName : "MTART",
                       width     : 90,
                       header    : { text: "자재유형" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "LGORT",
                       width     : 90,
                       header    : { text: "저장위치" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "KTGRM",
                       width     : 90,
                       header    : { text: "계정지정그룹" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "MTPOS",
                       width     : 90,
                       header    : { text: "품목범주그룹" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "DISMM",
                       width     : 90,
                       header    : { text: "MRP유형" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },                   
                   {
                       fieldName : "DISLS",
                       width     : 90,
                       header    : { text: "로트크기유형" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "BESKZ",
                       width     : 90,
                       header    : { text: "조달유형" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "FHORI",
                       width     : 110,
                       header    : { text: "일정계획마진키" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "SBDKZ",
                       width     : 90,
                       header    : { text: "개별/일괄" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "BKLAS",
                       width     : 90,
                       header    : { text: "평가클래스" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "MLAST",
                       width     : 90,
                       header    : { text: "가격결정" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "PEINH",
                       width     : 90,
                       header    : { text: "가격단위" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "HKMAT",
                       width     : 90,
                       header    : { text: "자재오리진" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "PRCTR",
                       width     : 90,
                       header    : { text: "손익센터" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "VPRSV",
                       width     : 90,
                       header    : { text: "가격관리" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "useYn",
                       width     : 90,
                       header    : { text: "사용유무" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true,
                       editor    : {type : "dropDown"},
                       values    : ["Y","N"],
                       labels    : ["Y","N"],
                       lookupDisplay : true
                   },
                   {
                       fieldName : "regId",
                       width     : 90,
                       header    : { text: "등록자" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "regDateTime",
                       width     : 140,
                       header    : { text: "등록일시" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "modId",
                       width     : 90,
                       header    : { text: "수정자" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "modDateTime",
                       width     : 140,
                       header    : { text: "수정일시" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   }
                 ];
   
   if (grid == secondGrid)
   {
       grid.setColumns(columns);
   }
}

//그리드 컬럼 Setting
function setThirdColumns(grid)
{
    var columns = [
                   {
                       fieldName : "setSeq",
                       width     : 0,
                       header    : { text: "SEQ" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "VTWEG",
                       width     : 90,
                       header    : { text: "유통경로" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true,
                       editor    : {type : "dropDown"},
                       values    : ["00","10"],
                       labels    : ["수출","내수"],
                       lookupDisplay : true
                   },
                   {
                       fieldName : "useYn",
                       width     : 90,
                       header    : { text: "사용유무" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true,
                       editor    : {type : "dropDown"},
                       values    : ["Y","N"],
                       labels    : ["Y","N"],
                       lookupDisplay : true
                   },
                   {
                       fieldName : "regId",
                       width     : 90,
                       header    : { text: "등록자" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "regDateTime",
                       width     : 140,
                       header    : { text: "등록일시" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "modId",
                       width     : 90,
                       header    : { text: "수정자" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "modDateTime",
                       width     : 140,
                       header    : { text: "수정일시" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   }
                 ];
   
   if (grid == thirdGrid)
   {
       grid.setColumns(columns);
   }
}

//그리드 컬럼 Setting
function setFourthColumns(grid)
{
    var columns = [
                   {
                       fieldName : "setSeq",
                       width     : 0,
                       header    : { text: "SEQ" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "WERKS",
                       width     : 90,
                       header    : { text: "플랜트" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true,
                       editor    : {type : "dropDown"},
                       values    : ["1110","1120","1130","1140","1150","1160","1170","1180"],
                       labels    : ["본사","연구소","냉장고","세탁기","압축기","주방기기","국내물류","영상"],
                       lookupDisplay : true
                   },
                   {
                       fieldName : "VABME",
                       width     : 90,
                       header    : { text: "가변OUn" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "KORDB",
                       width     : 90,
                       header    : { text: "소스리스트" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "DISPO",
                       width     : 90,
                       header    : { text: "MRP관리자" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "MATKL",
                       width     : 100,
                       header    : { text: "자재그룹" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true
                   },
                   {
                       fieldName : "useYn",
                       width     : 90,
                       header    : { text: "사용유무" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       editable  : true,
                       editor    : {type : "dropDown"},
                       values    : ["Y","N"],
                       labels    : ["Y","N"],
                       lookupDisplay : true
                   },
                   {
                       fieldName : "regId",
                       width     : 90,
                       header    : { text: "등록자" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "regDateTime",
                       width     : 140,
                       header    : { text: "등록일시" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "modId",
                       width     : 90,
                       header    : { text: "수정자" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   },
                   {
                       fieldName : "modDateTime",
                       width     : 140,
                       header    : { text: "수정일시" },
                       styles    : { textAlignment: "center" },
                       visible   : true,
                       readOnly  : true
                   }
                 ];
   
   if (grid == fourthGrid)
   {
       grid.setColumns(columns);
   }
}

//그리드 Option 설정
function setSecondOptions(grid)
{
  grid.setOptions(
  {
      panel :
      {
          visible : false
      },
      footer :
      {
          visible : false
      },
      checkBar :
      {
          visible : false,
          exclusive : true
      },
      statusBar :
      {
          visible : false
      },
      statusBar :
      {
          visible : false
      },
      edit :
      {
          insertable : true,
          appendable : true,
          updatable  : true,
          deletable  : true,
          deleteRowsConfirm : true,
          deleteRowsMessage : "Are you sure?"
      }
  });
}

//그리드 Option 설정
function setThirdOptions(grid)
{
  grid.setOptions(
  {
      panel :
      {
          visible : false
      },
      footer :
      {
          visible : false
      },
      checkBar :
      {
          visible : false,
          exclusive : true
      },
      statusBar :
      {
          visible : false
      },
      statusBar :
      {
          visible : false
      },
      edit :
      {
          insertable : true,
          appendable : true,
          updatable  : true,
          deletable  : true,
          deleteRowsConfirm : true,
          deleteRowsMessage : "Are you sure?"
      }
  });
}

//그리드 Option 설정
function setFourthOptions(grid)
{
  grid.setOptions(
  {
      panel :
      {
          visible : false
      },
      footer :
      {
          visible : false
      },
      checkBar :
      {
          visible : false,
          exclusive : true
      },
      statusBar :
      {
          visible : false
      },
      statusBar :
      {
          visible : false
      },
      edit :
      {
          insertable : true,
          appendable : true,
          updatable  : true,
          deletable  : true,
          deleteRowsConfirm : true,
          deleteRowsMessage : "Are you sure?"
      }
  });
}

//페이지 Action
function getPageAction(action)
{
    switch (action)
    {
        case 1 : // 
        
          $("#frm").attr({
                action : "DDSM920.E01.cmd",
                target : "_self",
                method : "POST"
            });
    
            $("#frm").submit();
    
            break;
        
        case 2 : // 진행중파생모델조회
            
          $("#frm").attr({
                action : "DDSM207.L01.cmd",
                target : "_self",
                method : "POST"
            });
    
            $("#frm").submit();
    
            break;
        case 3 : // 파생모델조회
            
            $("#frm").attr({
                  action : "DDSM208.L01.cmd",
                  target : "_self",
                  method : "POST"
              });
      
              $("#frm").submit();
      
              break;
        case 4 : // 모델Set 관리
            
            $("#frm").attr({
                  action : "DDSM203.L01.cmd",
                  target : "_self",
                  method : "POST"
              });
      
              $("#frm").submit();
      
            break;        
        case 5 : // 부품Set 관리
            
            $("#frm").attr({
                  action : "DDSM922.E01.cmd",
                  target : "_self",
                  method : "POST"
              });
      
              $("#frm").submit();
      
            break;
        case 6 : // 원부자재Set 관리
            
            $("#frm").attr({
                  action : "DDSM923.E01.cmd",
                  target : "_self",
                  method : "POST"
              });
      
              $("#frm").submit();
      
            break;
        case 7 : // 원부자재채번
            
            $("#frm").attr({
                  action : "DDSM924.E01.cmd",
                  target : "_self",
                  method : "POST"
              });
      
              $("#frm").submit();
      
            break;
            
        case 8 : // 기타매출자재 
            
            $("#frm").attr({
            	  action : "DDSM925.E01.cmd",
                  target : "_self",
                  method : "POST"
              });
      
              $("#frm").submit();
      
            break; 
            
		case 9 : // 판매법인Set 관리
            
            $("#frm").attr({
            	  action : "DDSM710.E01.cmd",
                  target : "_self",
                  method : "POST"
              });
      
              $("#frm").submit();
      
            break; 
    }
}

//기본모델 Action
function getPageAction1(action)
{
    switch (action)
    {
        case 1 : // 기본모델 조회
        
            mainProvider.clearRows();
        
            var jsonObj = {};
            jsonObj.sqlid   = 'Model.SM_ETC_SET_LIST';
            
            $.ajax({
                type       : "POST",
                url        : "DDSM.BASE.SERVICE.R00.cmd",
                dataType   : "json",
                data       : {"param" : JSON.stringify(jsonObj)},
                async      : false,
                beforeSend : function(xhr)
                {
                    // 전송 전 Code
                },
                success    : function(result)
                {
                    if(result.length > 0){
                        mainProvider.setRows(result);
                    }else{
                        alert("조회된 내용이 없습니다.");
                    }                    
                },
                error      : function(e)
                {
                    alert(e.responseText);
                }
            }); 
            
            break;
            
        case 2 :
            
            if(mainGrid.getItemCount() == 0) 
            {
                var row1 = {             
                        MBRSH : "",
                        VKORG : "",                        
                        SPART : "",
                        MATKL : "",
                        MTPOS_MARA : "",
                        TAXKM : "",                        
                        VERSG : "",
                        MTVFP : "",
                        TRAGR : "",
                        LADGR : "",                                                
                        useYn : "Y",
                        rowStatus  : "C"
                    };
                
                try {
                    mainProvider.insertRow(0, row1);
                } catch (err) {
                    alert(err);
                }
            }
            else
            {
                var current = mainGrid.getCurrent().itemIndex==-1?0:mainGrid.getCurrent();
                var dataRow = current.dataRow;
                
                var row2 = {             
                        MBRSH : "",
                        VKORG : "",                        
                        SPART : "",
                        MATKL : "",
                        MTPOS_MARA : "",
                        TAXKM : "",                        
                        VERSG : "",
                        MTVFP : "",
                        TRAGR : "",
                        LADGR : "",                                            
                        useYn : "Y",
                        rowStatus  : "C"
                    };                
                
                try {
                    mainProvider.insertRow(dataRow, row2);
                } catch (err) {
                    alert(err);
                }
            }
            
            break;
            
        case 3 : // 저장
            
            mainGrid.commit(true);
        
            if (confirm("'기본 기타매출자재 Data set'을 '저장' 하시겠습니까?") == false) return;
            
            // 서버로 전송할 Json Array Object 선언
            var jsonArray = [];

            // State가 변경된 Rows를 반환한다. Created,Updated,Deleted
            var m_rows = mainProvider.getAllStateRows();
            
            //신규 데이타
            if (m_rows.created.length > 0)
            {
                for( r in m_rows.created)
                {   //해당 Row Data를 Json개체로 받는다.
                    var j = mainProvider.getRow(m_rows.created[r]);
                       
                    j.command = "C";
                    j.sqlId   = "Model.SM_ETC_SET_INT";
                    j.regId   = '${SESSION_USER_ID}';
                    j.modId   = '${SESSION_USER_ID}';
                    j.setSeq  = isNullStr(j.setSeq);
                    j.MBRSH  = isNullStr(j.MBRSH);
                    j.VKORG  = isNullStr(j.VKORG);                                        
                    j.SPART  = isNullStr(j.SPART);
                    j.MATKL  = isNullStr(j.MATKL);                    
                    j.MTPOS_MARA  = isNullStr(j.MTPOS_MARA);
                    j.TAXKM  = isNullStr(j.TAXKM);
                    j.VERSG  = isNullStr(j.VERSG);
                    j.MTVFP  = isNullStr(j.MTVFP);
                    j.TRAGR  = isNullStr(j.TRAGR);
                    j.LADGR  = isNullStr(j.LADGR);                                           
                    j.useYn = isNullStr(j.useYn);
                    jsonArray.push(j);
                }
            }
            
            //수정 데이타
            if (m_rows.updated.length > 0)
            {
                for( r in m_rows.updated)
                {   //해당 Row Data를 Json개체로 받는다.
                    var j = mainProvider.getRow(m_rows.updated[r]);
                    
                    j.command = "U";
                    j.sqlId   = "Model.SM_ETC_SET_UPT";
                    j.regId   = '${SESSION_USER_ID}';
                    j.modId   = '${SESSION_USER_ID}';
                    j.setSeq  = isNullStr(j.setSeq);
                    j.MBRSH  = isNullStr(j.MBRSH);
                    j.VKORG  = isNullStr(j.VKORG);                                        
                    j.SPART  = isNullStr(j.SPART);
                    j.MATKL  = isNullStr(j.MATKL);                    
                    j.MTPOS_MARA  = isNullStr(j.MTPOS_MARA);
                    j.TAXKM  = isNullStr(j.TAXKM);
                    j.VERSG  = isNullStr(j.VERSG);
                    j.MTVFP  = isNullStr(j.MTVFP);
                    j.TRAGR  = isNullStr(j.TRAGR);
                    j.LADGR  = isNullStr(j.LADGR);
                    j.useYn = isNullStr(j.useYn);
                    jsonArray.push(j);
                }
            }
            
            if (jsonArray.length<=0) return;

            //실행쿼리 호출
            doAjax(jsonArray, function(){
               getPageAction1(1);
            });
        
            break;
    }
}

//파생모델 Action
function getPageAction2(action)
{
    switch (action)
    {
        case 1 : // 기본모델 조회
        
            secondProvider.clearRows();
        
            var jsonObj = {};
            jsonObj.sqlid   = 'Model.SM_ETC_KIND_SET_LIST';
            
            $.ajax({
                type       : "POST",
                url        : "DDSM.BASE.SERVICE.R00.cmd",
                dataType   : "json",
                data       : {"param" : JSON.stringify(jsonObj)},
                async      : false,
                beforeSend : function(xhr)
                {
                    // 전송 전 Code
                },
                success    : function(result)
                {
                    if(result.length > 0){
                        secondProvider.setRows(result);
                    }else{
                        alert("조회된 내용이 없습니다.");
                    }                    
                },
                error      : function(e)
                {
                    alert(e.responseText);
                }
            }); 
            
            break;
            
        case 2 :
            
            if(secondGrid.getItemCount() == 0) 
            {
                var row1 = {       
                        ZMATKL : "",
                        MTART : "",
                        LGORT : "",                        
                        KTGRM : "",
                        MTPOS : "",
                        DISMM : "",                        
                        DISLS : "",
                        BESKZ : "",
                        FHORI : "",
                        SBDKZ : "",
                        BKLAS : "",
                        MLAST : "",
                        PEINH : "",
                        HKMAT : "",
                        PRCTR : "",
                        VPRSV : "",
                        useYn : "Y",
                        rowStatus  : "C"
                    };
                
                try {
                    secondProvider.insertRow(0, row1);
                } catch (err) {
                    alert(err);
                }
            }
            else
            {
                var current = secondGrid.getCurrent().itemIndex==-1?0:secondGrid.getCurrent();
                var dataRow = current.dataRow;
                
                var row2 = {             
                        ZMATKL : "",
                        MTART : "",
                        LGORT : "",                        
                        KTGRM : "",
                        MTPOS : "",
                        DISMM : "",                        
                        DISLS : "",
                        BESKZ : "",
                        FHORI : "",
                        SBDKZ : "",
                        BKLAS : "",
                        MLAST : "",
                        PEINH : "",
                        HKMAT : "",
                        PRCTR : "",
                        VPRSV : "",               
                        useYn : "Y",
                        rowStatus  : "C"
                    };                
                
                try {
                    secondProvider.insertRow(dataRow, row2);
                } catch (err) {
                    alert(err);
                }
            }
            
            break;
            
        case 3 : // 저장
            
            secondGrid.commit(true);
        
            if (confirm("'기타매출자재 유형 Data set'을 '저장' 하시겠습니까?") == false) return;
            
            // 서버로 전송할 Json Array Object 선언
            var jsonArray = [];

            // State가 변경된 Rows를 반환한다. Created,Updated,Deleted
            var m_rows = secondProvider.getAllStateRows();
            
            //신규 데이타
            if (m_rows.created.length > 0)
            {
                for( r in m_rows.created)
                {   //해당 Row Data를 Json개체로 받는다.
                    var j = secondProvider.getRow(m_rows.created[r]);
                       
                    j.command = "C";
                    j.sqlId   = "Model.SM_ETC_KIND_SET_INT";
                    j.regId   = '${SESSION_USER_ID}';
                    j.modId   = '${SESSION_USER_ID}';
                    j.setSeq  = isNullStr(j.setSeq);
                    j.ZMATKL  = isNullStr(j.ZMATKL);
                    j.MTART  = isNullStr(j.MTART);
                    j.LGORT  = isNullStr(j.LGORT);               
                    j.KTGRM  = isNullStr(j.KTGRM);
                    j.MTPOS  = isNullStr(j.MTPOS);
                    j.DISMM  = isNullStr(j.DISMM);                    
                    j.DISLS  = isNullStr(j.DISLS);
                    j.BESKZ  = isNullStr(j.BESKZ);
                    j.FHORI  = isNullStr(j.FHORI);
                    j.SBDKZ  = isNullStr(j.SBDKZ);
                    j.BKLAS  = isNullStr(j.BKLAS);
                    j.MLAST  = isNullStr(j.MLAST);
                    j.PEINH  = isNullStr(j.PEINH);
                    j.HKMAT  = isNullStr(j.HKMAT);
                    j.PRCTR  = isNullStr(j.PRCTR);
                    j.VPRSV  = isNullStr(j.VPRSV);
                    j.useYn = isNullStr(j.useYn);
                    jsonArray.push(j);
                }
            }
            
            //수정 데이타
            if (m_rows.updated.length > 0)
            {
                for( r in m_rows.updated)
                {   //해당 Row Data를 Json개체로 받는다.
                    var j = secondProvider.getRow(m_rows.updated[r]);
                    
                    j.command = "U";
                    j.sqlId   = "Model.SM_ETC_KIND_SET_UPT";
                    j.regId   = '${SESSION_USER_ID}';
                    j.modId   = '${SESSION_USER_ID}';
                    j.setSeq  = isNullStr(j.setSeq);
                    j.ZMATKL  = isNullStr(j.ZMATKL);
                    j.MTART  = isNullStr(j.MTART);
                    j.LGORT  = isNullStr(j.LGORT);               
                    j.KTGRM  = isNullStr(j.KTGRM);
                    j.MTPOS  = isNullStr(j.MTPOS);
                    j.DISMM  = isNullStr(j.DISMM);                    
                    j.DISLS  = isNullStr(j.DISLS);
                    j.BESKZ  = isNullStr(j.BESKZ);
                    j.FHORI  = isNullStr(j.FHORI);
                    j.SBDKZ  = isNullStr(j.SBDKZ);
                    j.BKLAS  = isNullStr(j.BKLAS);
                    j.MLAST  = isNullStr(j.MLAST);
                    j.PEINH  = isNullStr(j.PEINH);
                    j.HKMAT  = isNullStr(j.HKMAT);
                    j.PRCTR  = isNullStr(j.PRCTR);
                    j.VPRSV  = isNullStr(j.VPRSV);
                    j.useYn = isNullStr(j.useYn);
                    jsonArray.push(j);
                }
            }
            
            if (jsonArray.length<=0) return;

            //실행쿼리 호출
            doAjax(jsonArray, function(){
               getPageAction2(1);
            });
        
            break;
    }
}

//제품/상품 모델 Action
function getPageAction3(action)
{
    switch (action)
    {
        case 1 : // 기본모델 조회
        
            thirdProvider.clearRows();
        
            var jsonObj = {};
            jsonObj.sqlid   = 'Model.SM_ETC_EXP_DOMS_SET_LIST';
            
            $.ajax({
                type       : "POST",
                url        : "DDSM.BASE.SERVICE.R00.cmd",
                dataType   : "json",
                data       : {"param" : JSON.stringify(jsonObj)},
                async      : false,
                beforeSend : function(xhr)
                {
                    // 전송 전 Code
                },
                success    : function(result)
                {
                    if(result.length > 0){
                        thirdProvider.setRows(result);
                    }else{
                        alert("조회된 내용이 없습니다.");
                    }                    
                },
                error      : function(e)
                {
                    alert(e.responseText);
                }
            }); 
            
            break;
            
        case 2 :
            
            if(thirdGrid.getItemCount() == 0) 
            {
                var row1 = {
                        VTWEG : "",
                        useYn : "Y",
                        rowStatus  : "C"
                    };
                
                try {
                    thirdProvider.insertRow(0, row1);
                } catch (err) {
                    alert(err);
                }
            }
            else
            {
                var current = thirdGrid.getCurrent().itemIndex==-1?0:thirdGrid.getCurrent();
                var dataRow = current.dataRow;
                
                var row2 = {             
                        VTWEG : "",             
                        useYn : "Y",
                        rowStatus  : "C"
                    };                
                
                try {
                    thirdProvider.insertRow(dataRow, row2);
                } catch (err) {
                    alert(err);
                }
            }
            
            break;
            
        case 3 : // 저장
            
            thirdGrid.commit(true);
        
            if (confirm("'기타매출자재 수출/내수 구분 Data set'을 '저장' 하시겠습니까?") == false) return;
            
            // 서버로 전송할 Json Array Object 선언
            var jsonArray = [];

            // State가 변경된 Rows를 반환한다. Created,Updated,Deleted
            var m_rows = thirdProvider.getAllStateRows();
            
            //신규 데이타
            if (m_rows.created.length > 0)
            {
                for( r in m_rows.created)
                {   //해당 Row Data를 Json개체로 받는다.
                    var j = thirdProvider.getRow(m_rows.created[r]);
                       
                    j.command = "C";
                    j.sqlId   = "Model.SM_ETC_EXP_DOMS_SET_INT";
                    j.regId   = '${SESSION_USER_ID}';
                    j.modId   = '${SESSION_USER_ID}';
                    j.setSeq  = isNullStr(j.setSeq);
                    j.VTWEG  = isNullStr(j.VTWEG);
                    j.useYn = isNullStr(j.useYn);
                    jsonArray.push(j);
                }
            }
            
            //수정 데이타
            if (m_rows.updated.length > 0)
            {
                for( r in m_rows.updated)
                {   //해당 Row Data를 Json개체로 받는다.
                    var j = thirdProvider.getRow(m_rows.updated[r]);
                    
                    j.command = "U";
                    j.sqlId   = "Model.SM_ETC_EXP_DOMS_SET_UPT";
                    j.regId   = '${SESSION_USER_ID}';
                    j.modId   = '${SESSION_USER_ID}';
                    j.setSeq  = isNullStr(j.setSeq);
                    j.VTWEG  = isNullStr(j.VTWEG);
                    jsonArray.push(j);
                }
            }
            
            if (jsonArray.length<=0) return;

            //실행쿼리 호출
            doAjax(jsonArray, function(){
               getPageAction3(1);
            });
        
            break;
    }
}

function getPageAction4(action)
{
    switch (action)
    {
        case 1 : // 기본모델 조회
        
            fourthProvider.clearRows();
        
            var jsonObj = {};
            jsonObj.sqlid   = 'Model.SM_ETC_PLANT_SET_LIST';
            
            $.ajax({
                type       : "POST",
                url        : "DDSM.BASE.SERVICE.R00.cmd",
                dataType   : "json",
                data       : {"param" : JSON.stringify(jsonObj)},
                async      : false,
                beforeSend : function(xhr)
                {
                    // 전송 전 Code
                },
                success    : function(result)
                {
                    if(result.length > 0){
                    	fourthProvider.setRows(result);
                    }else{
                        alert("조회된 내용이 없습니다.");
                    }                    
                },
                error      : function(e)
                {
                    alert(e.responseText);
                }
            }); 
            
            break;
            
        case 2 :
            
            if(fourthGrid.getItemCount() == 0) 
            {
                var row1 = {
                        WERKS : "",
                        VABME : "",
                        KORDB : "",
                        DISPO : "",
                        MATKL : "",
                        useYn : "Y",
                        rowStatus  : "C"
                    };
                
                try {
                	fourthProvider.insertRow(0, row1);
                } catch (err) {
                    alert(err);
                }
            }
            else
            {
                var current = fourthGrid.getCurrent().itemIndex==-1?0:fourthGrid.getCurrent();
                var dataRow = current.dataRow;
                
                var row2 = {             
                		WERKS : "",
                        VABME : "",
                        KORDB : "",
                        DISPO : "",    
                        MATKL : "",
                        useYn : "Y",
                        rowStatus  : "C"
                    };                
                
                try {
                	fourthProvider.insertRow(dataRow, row2);
                } catch (err) {
                    alert(err);
                }
            }
            
            break;
            
        case 3 : // 저장
            
        	fourthGrid.commit(true);
        
            if (confirm("'기타매출자재 플랜트 구분 Data set'을 '저장' 하시겠습니까?") == false) return;
            
            // 서버로 전송할 Json Array Object 선언
            var jsonArray = [];

            // State가 변경된 Rows를 반환한다. Created,Updated,Deleted
            var m_rows = fourthProvider.getAllStateRows();
            
            //신규 데이타
            if (m_rows.created.length > 0)
            {
                for( r in m_rows.created)
                {   //해당 Row Data를 Json개체로 받는다.
                    var j = fourthProvider.getRow(m_rows.created[r]);
                       
                    j.command = "C";
                    j.sqlId   = "Model.SM_ETC_PLANT_SET_INT";
                    j.regId   = '${SESSION_USER_ID}';
                    j.modId   = '${SESSION_USER_ID}';
                    j.setSeq  = isNullStr(j.setSeq);
                    j.WERKS  = isNullStr(j.WERKS);
                    j.VABME  = isNullStr(j.VABME);
                    j.KORDB  = isNullStr(j.KORDB);
                    j.DISPO  = isNullStr(j.DISPO);
                    j.MATKL  = isNullStr(j.MATKL);      
                    j.useYn = isNullStr(j.useYn);
                    jsonArray.push(j);
                }
            }
            
            //수정 데이타
            if (m_rows.updated.length > 0)
            {
                for( r in m_rows.updated)
                {   //해당 Row Data를 Json개체로 받는다.
                    var j = fourthProvider.getRow(m_rows.updated[r]);
                    
                    j.command = "U";
                    j.sqlId   = "Model.SM_ETC_PLANT_SET_UPT";
                    j.regId   = '${SESSION_USER_ID}';
                    j.modId   = '${SESSION_USER_ID}';
                    j.setSeq  = isNullStr(j.setSeq);
                    j.WERKS  = isNullStr(j.WERKS);
                    j.VABME  = isNullStr(j.VABME);
                    j.KORDB  = isNullStr(j.KORDB);
                    j.DISPO  = isNullStr(j.DISPO);
                    j.MATKL  = isNullStr(j.MATKL);      
                    jsonArray.push(j);
                }
            }
            
            if (jsonArray.length<=0) return;

            //실행쿼리 호출
            doAjax(jsonArray, function(){
               getPageAction4(1);
            });
        
            break;
    }
}
</script>
</head>

<body>
<div class="wrap" >
    <%@ include file="/views/include/top.jsp"%>
    <div class="container">
            <div class="sub_nav" class="navigation">홈<img src="<%=request.getContextPath()%>/resources/css/images/img_subnav.gif" style="vertical-align:middle; margin-left: 10px; margin-right: 10px;"/>정보관리
            <img src="<%=request.getContextPath()%>/resources/css/images/img_subnav.gif" style="vertical-align:middle; margin-left: 10px; margin-right: 10px;"/>운영관리            
            <img src="<%=request.getContextPath()%>/resources/css/images/img_subnav.gif" style="vertical-align:middle; margin-left: 10px; margin-right: 10px;"/>기타매출자재Set 관리</div>                        
            <div class="hspace6"></div>
            <div class="subtitle_title"><%=_mm.getMenuName() %></div>
                <div class="content_tab">
                   <ul>
                      <!-- <li><a href="javascript:getPageAction(3)" class="content_tab_anchor"><span class="content_tab_anchor_left">파생모델조회</span></a></li>    
                      <li><span class="content_tab_space"></span></li>                    
                      <li><a href="javascript:getPageAction(2)" class="content_tab_anchor"><span class="content_tab_anchor_left">진행중파생모델조회</span></a></li>
                      <li><span class="content_tab_space"></span></li>                    
                      <li><a href="javascript:getPageAction(1)" class="content_tab_anchor"><span class="content_tab_anchor_left">Mailing 관리</span></a></li>                                        
                      <li><span class="content_tab_space"></span></li> -->                    
                      <li><a href="javascript:getPageAction(4)" class="content_tab_anchor"><span class="content_tab_anchor_left">모델Set 관리</span></a></li>
                      <li><span class="content_tab_space"></span></li>
                      <li><a href="javascript:getPageAction(5)" class="content_tab_anchor"><span class="content_tab_anchor_left">부품Set 관리</span></a></li>
                      <li><span class="content_tab_space"></span></li>
                      <li><a href="javascript:getPageAction(6)" class="content_tab_anchor"><span class="content_tab_anchor_left">원부자재Set 관리</span></a></li>
                      <li><span class="content_tab_space"></span></li>
                      <li><a href="javascript:getPageAction(7)" class="content_tab_anchor"><span class="content_tab_anchor_left">원부자재채번 관리</span></a></li>
                      <li><span class="content_tab_space"></span></li>
                      <li><a href="javascript:getPageAction(8)" class="content_tab_active"><span class="content_tab_active_left">기타매출자재Set 관리</span></a></li>
                      <li><span class="content_tab_space"></span></li>
                      <li><a href="javascript:getPageAction(9)" class="content_tab_anchor"><span class="content_tab_anchor_left">판매법인Set 관리</span></a></li>
                   </ul>
                </div>
                <div class="content">
                    <form id="frm" name="frm">                    
                    <div class="subtitle_all">
                        <div class="item_title"><span class="text_black14b">기타매출자재 기본 Data Set</span></div>
<%--                        <jsp:include page="/views/status/ddsm_203_L02.jsp" flush="false"> --%>
<%--                          <jsp:param name="current" value="DDHMT01.T31" /> --%>
<%--                            </jsp:include> --%>
                        <div class="subtitle_btngroup">
                            <a href="javascript:getPageAction1(1);" class="btn_search"><span class="btn_search_left">조회</span></a>             
                            <a href="javascript:getPageAction1(2);" class="btn_add"><span class="btn_add_left">등록</span></a>
                            <a href="javascript:getPageAction1(3);" class="btn_check"><span class="btn_check_left">저장</span></a>     
                        </div>                
                    </div>    
                    
                    <div id="grdMain"></div>
                    
                    <div class="subtitle_all">
                        <div class="item_title"><span class="text_black14b">기타매출자재 유형 Data Set</span></div>
                        <div class="subtitle_btngroup">
                            <a href="javascript:getPageAction2(1);" class="btn_search"><span class="btn_search_left">조회</span></a>             
                            <a href="javascript:getPageAction2(2);" class="btn_add"><span class="btn_add_left">등록</span></a>
                            <a href="javascript:getPageAction2(3);" class="btn_check"><span class="btn_check_left">저장</span></a>     
                        </div>                
                    </div>    
                    
                    <div id="grdMain2"></div>
                    
                    <div class="subtitle_all">
                        <div class="item_title"><span class="text_black14b">기타매출자재 수출/내수 Data Set</span></div>
                        <div class="subtitle_btngroup">
                            <a href="javascript:getPageAction3(1);" class="btn_search"><span class="btn_search_left">조회</span></a>             
                            <a href="javascript:getPageAction3(2);" class="btn_add"><span class="btn_add_left">등록</span></a>
                            <a href="javascript:getPageAction3(3);" class="btn_check"><span class="btn_check_left">저장</span></a>     
                        </div>                
                    </div>    
                    
                    <div id="grdMain3"></div>
                    
                    <div class="subtitle_all">
                        <div class="item_title"><span class="text_black14b">기타매출자재 플랜트 Data Set</span></div>
                        <div class="subtitle_btngroup">
                            <a href="javascript:getPageAction4(1);" class="btn_search"><span class="btn_search_left">조회</span></a>             
                            <a href="javascript:getPageAction4(2);" class="btn_add"><span class="btn_add_left">등록</span></a>
                            <a href="javascript:getPageAction4(3);" class="btn_check"><span class="btn_check_left">저장</span></a>     
                        </div>                
                    </div>    
                    
                    <div id="grdMain4"></div>
                    
                    <div class="hspace3"></div>
                    </form>                    
                </div>
    </div><!-- container -->
</div><!-- wrap -->

<%@ include file="/views/include/bottom.jsp"%>
</body>
</html>
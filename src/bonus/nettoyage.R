splash=function(x){
    res=NULL
    for (i in x) res=paste(res, i)
    res
}

#Suppression des script s(<script .... </script>)
removeScript=function(t){
    sp=strsplit(t, "<script")
    vec=sapply(sp[[1]], gsub, pattern=".*</script>", replace=" ")
    PlainTextDocument(splash(vec))
}

#Suppression de toutes les balises
removeBalises=function(x){
    t1=gsub("<[^>]*>", " ", x)
    PlainTextDocument(gsub("[ \t]+"," ",t1))
}



commonWebEpure1 <- c("backgroundcolor","backgroundfff","block","border","borderbottom","borderbottompx","borderbottomwidth","borderleft","borderpx",
"borderright","bordertop","bordertoppx","borderwidth","borderwidthpx","color","coloraa","colorabc","colorb","colorc","colorccc","colorff","colorfff",
"colorgray","displayblock","displayinline","displaynone",
"else","fff","ffffff","font","fontbold","fontfamily","fontsize","fontsizepx","fontstyle","fontstyleitalic","fontstylenormal","fontweight","fontweightbold","fontweightnormal",
"gtgt","gtnbspnbsp","height","heightpx","helvetica","html",
"if","ip","javascript","letterspacing","lineheight","lineheightem","link",
"margin","marginbottom","marginbottompx","marginem","marginleft","marginleftem","marginpx","marginrightem","margintop",
"maxwidthpx","nbsp","nbspnbspnbsp","nbspnbspnbspnbsp","nbspnbspnbspnbspnbsp","nbspnbspnbspnbspnbspnbsp","nbspnbspnbspnbspnbspnbspnbsp","nbspnbspnbspnbspnbspnbspnbspnbsp","nbspnbspnbspsoni",
"nbspsection","nbspstyle","nbspterm","nbsptext","newsnbspnbsp",
"padding","paddingbottom","paddingbottomem","paddingleft","paddingleftpx","paddingpx","paddingtop","paddingtoppx","page","path","pmnbsp","pointer",
"random","remov","sidebar","templat",
"textalign","textaligncenter","textalignleft","textalignright","textdecor","textdecoration","textdecorationnone","textdecorationunderline","textindentpx","texttransform","texttransformlowercase",
"texttransformuppercase","underlin","underline","websit","website",
"wide","width","widthpx","www")


nettoyage <- function(training)
{
  training<-tm_map(training,content_transformer(tolower))
  training<-tm_map(training,content_transformer(splash))
  training<-tm_map(training,content_transformer(removeScript))
  training<-tm_map(training,content_transformer(removeBalises))
  training<-tm_map(training,removeNumbers)
  training<-tm_map(training,removeWords,words=commonWebEpure1)
  training<-tm_map(training,stemDocument)
  training<-tm_map(training,removePunctuation)
  return(training);
}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Handler.Article where

import Import
import Handler.Blog
import Yesod.Form.Bootstrap3

getArticleR :: BlogId -> Handler Html
getArticleR blogId = do
  blog <- runDB $ get404 blogId
  (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm $ blogForm (Just blog)
  defaultLayout $ do
        setTitle $ toHtml $ blogTitle blog
        addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/highlight.min.js"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/styles/zenburn.min.css"
        $(widgetFile "article")


postArticleR :: BlogId -> Handler Html
postArticleR blogId = do
    blog <- runDB $ get404 blogId
    ((res, widget), enctype) <- runFormPost $ renderBootstrap3 BootstrapBasicForm $ blogForm (Just blog)
    case res of
        FormSuccess updatedBlog -> do
            runDB $ replace blogId $ updatedBlog
            redirect $ ArticleR blogId
        _ -> defaultLayout $(widgetFile "article")

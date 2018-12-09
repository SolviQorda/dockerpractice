{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Handler.Blog where

import Import
import Yesod.Form.Bootstrap3
import Yesod.Text.Markdown

blogForm :: Maybe Blog -> AForm Handler Blog
blogForm mblog = Blog
        <$> areq textField (bfs ("Title" :: Text)) (blogTitle <$> mblog)
        <*> areq markdownField (bfs ("Article" :: Text)) (blogArticle <$> mblog)
        <*> lift (liftIO getCurrentTime)

getBlogR :: Handler Html
getBlogR = do
  (widget, enctype) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm $ blogForm Nothing
  allPosts <- runDB $ selectList [] [Desc BlogId]
  currentPost <- runDB $ selectFirst [] [Desc BlogId]
  defaultLayout $ do
    setTitle "I blog when it works"
    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"
    addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/highlight.min.js"
    addScriptRemote "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.2.0/js/collapse.js"
    addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.5/styles/zenburn.min.css"
    $(widgetFile "blog")

postBlogR :: Handler Html
postBlogR = do
  ((res, widget), enctype) <- runFormPost $ renderBootstrap3 BootstrapBasicForm $ blogForm Nothing
  allPosts <- runDB $ selectList [] [Desc BlogId]
  currentPost <- runDB $ selectFirst [] [Desc BlogId]
  case res of
    FormSuccess blog -> do
      blogId <- runDB $ insert blog
      redirect $ ArticleR blogId
    _ -> defaultLayout $(widgetFile "blog")

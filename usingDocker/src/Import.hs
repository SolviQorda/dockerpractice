module Import
    ( module Import
    ) where

import Foundation            as Import
import Import.NoFoundation   as Import

-- date formatting for templates
dateTimeFormat :: String
dateTimeFormat = "%e %B %Y %H:%M"

formatDateStr :: UTCTime -> String
formatDateStr = formatTime defaultTimeLocale dateTimeFormat
-- end date formatting

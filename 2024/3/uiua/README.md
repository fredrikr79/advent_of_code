# part 1

[solution](https://uiua.org/pad?src=0_14_0-dev_5__JmZyYXMgImlucHV0IgoKIyB0aGUgcmVnZXggZXhwcmVzc2lvbiBzdHJpbmcKIyB0byBtYXRjaCB0aGUgbXVsIGluc3RydWN0aW9ucwojIGFuZCBjYXB0dXJlIHRoZSBvcGVyYW5kcwpNdWwg4oaQICQgbXVsXCgoXGQrKSwoXGQrKVwpCgojIG1hdGNoIHRoZSBtdWwgZXhwcmVzc2lvbiwKIyBkcm9wIHRoZSBmdWxsICJtdWwoLi4uKSIgc3RyaW5nLCAKIyBwYXJzZSBlYWNoIG9wZXJhbmQgdG8gaW50ClBhcnNlIOKGkCDiiLXii5Ug4omh4oaYMSByZWdleCBNdWwKCiMgbXVsdGlwbHkgdGhlIG51bWJlcnMgaW4gZWFjaCByb3csCiMgc3VtIHRoZSBwcm9kdWN0cwpTb2wg4oaQIC8rIOKJoS_DlwoKU29sIFBhcnNlCg==)

i first solved it this morning using vim, since i had no idea how to use regex in uiua. this is how i did it in vim (with some regex help from [kagi assistant](https://help.kagi.com/kagi/ai/assistant.html)):

```
:e "input"
100J                                  # there are few lines, join them all
:%s/\(mul(\d\+,\d\+)\)\|\(.\)/\1/g    # find all mul expressions
:%s/mul(\(\d+\),\(\d+\))/\1*\2+/g     # replace all mul expressions with the operands multiplied together with a + appended
$x                                    # remove last +
:'<,'>s/.*/\=eval(submatch(0))        # evaluate the expression
```

my uiua solution is very similar

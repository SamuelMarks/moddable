/*---
description: 
flags: [onlyStrict]
---*/

let data = {};

const anchorableContent = new Text(data, { anchor: "ANCHORABLE_CONTENT" })
assert.sameValue(data["ANCHORABLE_CONTENT"], anchorableContent, "Object should have an anchor");

const ContentTemplate = Text.template($ => ({ anchor: "ANCHORABLE_CONTENT2" }));
const anchorableContent2 = new ContentTemplate(data);
assert.sameValue(data["ANCHORABLE_CONTENT2"], anchorableContent2, "Object should have an anchor");

const ContentTemplate2 = Text.template($ => ({}));
const anchorableContent3 = new ContentTemplate2(data, { anchor: "ANCHORABLE_CONTENT3" });
assert.sameValue(data["ANCHORABLE_CONTENT3"], anchorableContent3, "Object should have an anchor");

// Check that anchors are only created in the instantiating data object 
data = {};
let data2 = {};

const content = new Text(data, { anchor: "CONTENT" });
const container = new Container(data2, { anchor: "CONTAINER", contents: [content] });

assert.sameValue(data["CONTAINER"], undefined, "container object should not have an anchor in `data` object");
assert.sameValue(data["CONTENT"], content, "content object should have an anchor in `data` object");

assert.sameValue(data2["CONTAINER"], container, "container object should have an anchor in `data2` object");
assert.sameValue(data2["CONTENT"], undefined, "content object should not have an anchor in `data2` object");
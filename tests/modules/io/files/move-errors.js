/*---
description: 
flags: [module]
---*/

import files from "./files-fixture.js";

const pathFrom = "testdir";
const pathTo = "dirtest";

assert.throws(Error, () => files.move(pathFrom, pathTo));
assert.throws(SyntaxError, () => files.move(pathFrom));
assert.throws(SyntaxError, () => files.move());

files.create(pathFrom);
assert.throws(SyntaxError, () => files.move.call(new $TESTMC.HostObject, pathFrom, pathTo));
assert.throws(Error, () => files.move(pathFrom, "../" + pathTo));
assert.throws(Error, () => files.move("../" + pathFrom, pathTo));
files.move(pathFrom, pathTo);
files.delete(pathTo);

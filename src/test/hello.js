import regeneratorRuntime from "regenerator-runtime-only";

export function testSubstring(test) {
	test.equal("foo".substring(1), "oo");
	test.done();
}

function waitABit() {
	return new Promise( function(resolve, reject) {
		setTimeout(() => resolve(), 500);
	});
}

export async function testSomeAsyncThing(test) {
	test.ok(true, "It's going to be okay!");
	await waitABit();
	test.ok(true, "Yay we waited.");
	test.done();
}

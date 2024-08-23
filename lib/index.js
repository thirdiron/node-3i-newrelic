'use strict';

let newrelic;

if ((
    process.env.NODE_ENV == 'development' || 
    process.env.NODE_ENV == 'production'
    ) && !!process.env.NEW_RELIC_LICENSE_KEY
  ) {
  // newrelic's nodeJS module is effectful so we
  // need to only require it when we're actually
  // instrumenting our process.
  newrelic = require('newrelic');
}

/*****
 * Instruments a function that resolves to a promise as
 * a segment in new relic
 * segmentName: name to use for segment in New Relic's reports
 * segmentFunc: the async, promise returning function that you want to measure
 *
 * returns: function wrapping segmentFunc that measures time from invocation
 * to promise resolution in New Relic
 *
 * Generally segments use a naming scheme of `moduleName.methodName`.  It's simple
 * and should work well enough to make segments easy to identify in the New Relic admin
 */
exports.instrumentSegment = function instrumentSegment(segmentName, segmentFunc) {
  if (!newrelic) {
    return segmentFunc;
  }

  return function wrappedSegmentInvocation() {
    return newrelic.startSegment(segmentName, false, () => { return segmentFunc.apply(this, arguments); });
  };
};

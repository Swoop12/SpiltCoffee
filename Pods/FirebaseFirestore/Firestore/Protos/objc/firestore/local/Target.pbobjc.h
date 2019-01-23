/*
 * Copyright 2018 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: firestore/local/target.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class GCFSTarget_DocumentsTarget;
@class GCFSTarget_QueryTarget;
@class GPBTimestamp;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - FSTPBTargetRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface FSTPBTargetRoot : GPBRootObject
@end

#pragma mark - FSTPBTarget

typedef GPB_ENUM(FSTPBTarget_FieldNumber) {
  FSTPBTarget_FieldNumber_TargetId = 1,
  FSTPBTarget_FieldNumber_SnapshotVersion = 2,
  FSTPBTarget_FieldNumber_ResumeToken = 3,
  FSTPBTarget_FieldNumber_LastListenSequenceNumber = 4,
  FSTPBTarget_FieldNumber_Query = 5,
  FSTPBTarget_FieldNumber_Documents = 6,
};

typedef GPB_ENUM(FSTPBTarget_TargetType_OneOfCase) {
  FSTPBTarget_TargetType_OneOfCase_GPBUnsetOneOfCase = 0,
  FSTPBTarget_TargetType_OneOfCase_Query = 5,
  FSTPBTarget_TargetType_OneOfCase_Documents = 6,
};

/**
 * A Target is a long-lived data structure representing a resumable listen on a
 * particular user query. While the query describes what to listen to, the
 * Target records data about when the results were last updated and enough
 * information to be able to resume listening later.
 **/
@interface FSTPBTarget : GPBMessage

/**
 * An auto-generated sequential numeric identifier for the target. This
 * serves as the identity of the target, and once assigned never changes.
 **/
@property(nonatomic, readwrite) int32_t targetId;

/**
 * The last snapshot version received from the Watch Service for this target.
 *
 * This is the same value as TargetChange.read_time
 **/
@property(nonatomic, readwrite, strong, null_resettable) GPBTimestamp *snapshotVersion;
/** Test to see if @c snapshotVersion has been set. */
@property(nonatomic, readwrite) BOOL hasSnapshotVersion;

/**
 * An opaque, server-assigned token that allows watching a query to be
 * resumed after disconnecting without retransmitting all the data that
 * matches the query. The resume token essentially identifies a point in
 * time from which the server should resume sending results.
 *
 * This is related to the snapshot_version in that the resume_token
 * effectively also encodes that value, but the resume_token is opaque and
 * sometimes encodes additional information.
 *
 * A consequence of this is that the resume_token should be used when asking
 * the server to reason about where this client is in the watch stream, but
 * the client should use the snapshot_version for its own purposes.
 *
 * This is the same value as TargetChange.resume_token
 **/
@property(nonatomic, readwrite, copy, null_resettable) NSData *resumeToken;

/**
 * A sequence number representing the last time this query was listened to,
 * used for garbage collection purposes.
 *
 * Conventionally this would be a timestamp value, but device-local clocks
 * are unreliable and they must be able to create new listens even while
 * disconnected. Instead this should be a monotonically increasing number
 * that's incremented on each listen call.
 *
 * This is different from the target_id since the target_id is an immutable
 * identifier assigned to the Target on first use while
 * last_listen_sequence_number is updated every time the query is listened
 * to.
 **/
@property(nonatomic, readwrite) int64_t lastListenSequenceNumber;

/** The server-side type of target to listen to. */
@property(nonatomic, readonly) FSTPBTarget_TargetType_OneOfCase targetTypeOneOfCase;

/** A target specified by a query. */
@property(nonatomic, readwrite, strong, null_resettable) GCFSTarget_QueryTarget *query;

/** A target specified by a set of document names. */
@property(nonatomic, readwrite, strong, null_resettable) GCFSTarget_DocumentsTarget *documents;

@end

/**
 * Clears whatever value was set for the oneof 'targetType'.
 **/
void FSTPBTarget_ClearTargetTypeOneOfCase(FSTPBTarget *message);

#pragma mark - FSTPBTargetGlobal

typedef GPB_ENUM(FSTPBTargetGlobal_FieldNumber) {
  FSTPBTargetGlobal_FieldNumber_HighestTargetId = 1,
  FSTPBTargetGlobal_FieldNumber_HighestListenSequenceNumber = 2,
  FSTPBTargetGlobal_FieldNumber_LastRemoteSnapshotVersion = 3,
  FSTPBTargetGlobal_FieldNumber_TargetCount = 4,
};

/**
 * Global state tracked across all Targets, tracked separately to avoid the
 * need for extra indexes.
 **/
@interface FSTPBTargetGlobal : GPBMessage

/**
 * The highest numbered target id across all Targets.
 *
 * See Target.target_id.
 **/
@property(nonatomic, readwrite) int32_t highestTargetId;

/**
 * The highest numbered last_listen_sequence_number across all Targets.
 *
 * See Target.last_listen_sequence_number.
 **/
@property(nonatomic, readwrite) int64_t highestListenSequenceNumber;

/**
 * A global snapshot version representing the last consistent snapshot we
 * received from the backend. This is monotonically increasing and any
 * snapshots received from the backend prior to this version (e.g. for
 * targets resumed with a resume_token) should be suppressed (buffered) until
 * the backend has caught up to this snapshot_version again. This prevents
 * our cache from ever going backwards in time.
 *
 * This is updated whenever our we get a TargetChange with a read_time and
 * empty target_ids.
 **/
@property(nonatomic, readwrite, strong, null_resettable) GPBTimestamp *lastRemoteSnapshotVersion;
/** Test to see if @c lastRemoteSnapshotVersion has been set. */
@property(nonatomic, readwrite) BOOL hasLastRemoteSnapshotVersion;

/** On platforms that need it, holds the number of targets persisted. */
@property(nonatomic, readwrite) int32_t targetCount;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
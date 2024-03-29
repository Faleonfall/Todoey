////////////////////////////////////////////////////////////////////////////
//
// Copyright 2015 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#ifndef REALM_OBJECT_STORE_HPP
#define REALM_OBJECT_STORE_HPP

#include <realm/object-store/property.hpp>
#include <realm/exceptions.hpp>

#include <realm/table_ref.hpp>
#include <realm/util/optional.hpp>

#include <functional>
#include <string>
#include <unordered_set>
#include <vector>
#include <limits>

namespace realm {
class Group;
class Transaction;
class Schema;
class SchemaChange;
class StringData;
enum class SchemaMode : uint8_t;

namespace util {
template <typename... Args>
std::string format(const char* fmt, Args&&... args);
}

class ObjectStore {
public:
    // Schema version used for uninitialized Realms
    static constexpr uint64_t NotVersioned = std::numeric_limits<uint64_t>::max();

    // get the last set schema version
    static uint64_t get_schema_version(Group const& group);

    // set the schema version without any checks
    // and the tables for the schema version and the primary key are created if they don't exist
    // NOTE: must be performed within a write transaction
    static void set_schema_version(Group& group, uint64_t version);

    // check if all of the changes in the list can be applied automatically, or
    // throw if any of them require a schema version bump and migration function
    static void verify_no_migration_required(std::vector<SchemaChange> const& changes);

    // Similar to above, but returns a bool rather than throwing/not throwing
    static bool needs_migration(std::vector<SchemaChange> const& changes);

    // check if any of the schema changes in the list are forbidden in
    // additive-only mode, and if any are throw an exception
    // returns true if any of the changes are not no-ops
    static bool verify_valid_additive_changes(std::vector<SchemaChange> const& changes, bool update_indexes = false);

    // check if the schema changes made by a different process made any changes
    // which will prevent us from being able to continue (such as removing a
    // property we were relying on)
    static void verify_valid_external_changes(std::vector<SchemaChange> const& changes);

    static void verify_compatible_for_immutable_and_readonly(std::vector<SchemaChange> const& changes);

    // check if changes is empty, and throw an exception if not
    static void verify_no_changes_required(std::vector<SchemaChange> const& changes);

    // updates a Realm from old_schema to the given target schema, creating and updating tables as needed
    // passed in target schema is updated with the correct column mapping
    // optionally runs migration function if schema is out of date
    // NOTE: must be performed within a write transaction
    static void apply_schema_changes(Transaction& group, uint64_t schema_version, Schema& target_schema,
                                     uint64_t target_schema_version, SchemaMode mode,
                                     std::vector<SchemaChange> const& changes, bool handle_automatically_backlinks,
                                     std::function<void()> migration_function = {},
                                     bool save_schema_version_on_version_decrease = false);

    static void apply_additive_changes(Group&, std::vector<SchemaChange> const&, bool update_indexes);

    // get a table for an object type
    static realm::TableRef table_for_object_type(Group& group, StringData object_type);
    static realm::ConstTableRef table_for_object_type(Group const& group, StringData object_type);

    // get existing Schema from a group
    static Schema schema_from_group(Group const& group);

    static void set_schema_keys(Group const& group, Schema& schema);

    // deletes the table for the given type
    static void delete_data_for_object(Group& group, StringData object_type);

    // indicates if this group contains any objects
    static bool is_empty(Group const& group);

    // renames the object_type's column of the old_name to the new name
    static void rename_property(Group& group, Schema& schema, StringData object_type, StringData old_name,
                                StringData new_name);

    static std::string table_name_for_object_type(StringData class_name);
    static StringData object_type_for_table_name(StringData table_name);

private:
    friend class ObjectSchema;
};

class InvalidSchemaVersionException : public LogicError {
public:
    InvalidSchemaVersionException(uint64_t old_version, uint64_t new_version, bool must_exactly_equal);
    uint64_t old_version() const
    {
        return m_old_version;
    }
    uint64_t new_version() const
    {
        return m_new_version;
    }

private:
    uint64_t m_old_version, m_new_version;
};

// Schema validation exceptions
struct ObjectSchemaValidationException {
    ObjectSchemaValidationException(std::string message)
        : m_message(std::move(message))
    {
    }

    template <typename... Args>
    ObjectSchemaValidationException(const char* fmt, Args&&... args)
        : m_message(util::format(fmt, std::forward<Args>(args)...))
    {
    }
    std::string m_message;
};

struct SchemaValidationException : public LogicError {
    SchemaValidationException(std::vector<ObjectSchemaValidationException> const& errors);
};

struct SchemaMismatchException : public LogicError {
    SchemaMismatchException(std::vector<ObjectSchemaValidationException> const& errors);
};

struct InvalidAdditiveSchemaChangeException : public LogicError {
    InvalidAdditiveSchemaChangeException(std::vector<ObjectSchemaValidationException> const& errors);
};
struct InvalidReadOnlySchemaChangeException : public LogicError {
    InvalidReadOnlySchemaChangeException(std::vector<ObjectSchemaValidationException> const& errors);
};

struct InvalidExternalSchemaChangeException : public LogicError {
    InvalidExternalSchemaChangeException(std::vector<ObjectSchemaValidationException> const& errors);
};
} // namespace realm

#endif /* defined(REALM_OBJECT_STORE_HPP) */

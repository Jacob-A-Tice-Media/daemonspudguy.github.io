# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Datastudio < RegexLexer
      tag 'datastudio'
      filenames '*.job'
      mimetypes 'text/x-datastudio'

      title "Datastudio"
      desc 'Datastudio scripting language'

      id = /@?[_a-z]\w*/i

      def self.sql_keywords
        @sql_keywords ||= %w(
          ABORT ABS ABSOLUTE ACCESS ADA ADD ADMIN AFTER AGGREGATE ALIAS
          ALL ALLOCATE ALTER ANALYSE ANALYZE AND ANY ARE AS ASC ASENSITIVE
          ASSERTION ASSIGNMENT ASYMMETRIC AT ATOMIC AUTHORIZATION
          AVG BACKWARD BEFORE BEGIN BETWEEN BITVAR BIT_LENGTH BOTH
          BREADTH BY C CACHE CALL CALLED CARDINALITY CASCADE CASCADED
          CASE CAST CATALOG CATALOG_NAME CHAIN CHARACTERISTICS
          CHARACTER_LENGTH CHARACTER_SET_CATALOG CHARACTER_SET_NAME
          CHARACTER_SET_SCHEMA CHAR_LENGTH CHECK CHECKED CHECKPOINT
          CLASS CLASS_ORIGIN CLOB CLOSE CLUSTER COALSECE COBOL COLLATE
          COLLATION COLLATION_CATALOG COLLATION_NAME COLLATION_SCHEMA
          COLUMN COLUMN_NAME COMMAND_FUNCTION COMMAND_FUNCTION_CODE
          COMMENT COMMIT COMMITTED COMPLETION CONDITION_NUMBER
          CONNECT CONNECTION CONNECTION_NAME CONSTRAINT CONSTRAINTS
          CONSTRAINT_CATALOG CONSTRAINT_NAME CONSTRAINT_SCHEMA
          CONSTRUCTOR CONTAINS CONTINUE CONVERSION CONVERT COPY
          CORRESPONTING COUNT CREATE CREATEDB CREATEUSER CROSS CUBE
          CURRENT CURRENT_DATE CURRENT_PATH CURRENT_ROLE CURRENT_TIME
          CURRENT_TIMESTAMP CURRENT_USER CURSOR CURSOR_NAME CYCLE DATA
          DATABASE DATETIME_INTERVAL_CODE DATETIME_INTERVAL_PRECISION
          DAY DEALLOCATE DECLARE DEFAULT DEFAULTS DEFERRABLE DEFERRED
          DEFINED DEFINER DELETE DELIMITER DELIMITERS DEREF DESC DESCRIBE
          DESCRIPTOR DESTROY DESTRUCTOR DETERMINISTIC DIAGNOSTICS
          DICTIONARY DISCONNECT DISPATCH DISTINCT DO DOMAIN DROP
          DYNAMIC DYNAMIC_FUNCTION DYNAMIC_FUNCTION_CODE EACH ELSE
          ENCODING ENCRYPTED END END-EXEC EQUALS ESCAPE EVERY EXCEPT
          ESCEPTION EXCLUDING EXCLUSIVE EXEC EXECUTE EXISTING EXISTS
          EXPLAIN EXTERNAL EXTRACT FALSE FETCH FINAL FIRST FOR FORCE
          FOREIGN FORTRAN FORWARD FOUND FREE FREEZE FROM FULL FUNCTION
          G GENERAL GENERATED GET GLOBAL GO GOTO GRANT GRANTED GROUP
          GROUPING HANDLER HAVING HIERARCHY HOLD HOST IDENTITY IGNORE
          ILIKE IMMEDIATE IMMUTABLE IMPLEMENTATION IMPLICIT IN INCLUDING
          INCREMENT INDEX INDITCATOR INFIX INHERITS INITIALIZE INITIALLY
          INNER INOUT INPUT INSENSITIVE INSERT INSTANTIABLE INSTEAD
          INTERSECT INTO INVOKER IS ISNULL ISOLATION ITERATE JOIN KEY
          KEY_MEMBER KEY_TYPE LANCOMPILER LANGUAGE LARGE LAST LATERAL
          LEADING LEFT LENGTH LESS LEVEL LIKE LIMIT LISTEN LOAD LOCAL
          LOCALTIME LOCALTIMESTAMP LOCATION LOCATOR LOCK LOWER MAP MATCH
          MAX MAXVALUE MESSAGE_LENGTH MESSAGE_OCTET_LENGTH MESSAGE_TEXT
          METHOD MIN MINUTE MINVALUE MOD MODE MODIFIES MODIFY MONTH
          MORE MOVE MUMPS NAMES NATURAL NCLOB NEW NEXT
          NO NOCREATEDB NOCREATEUSER NONE NOT NOTHING NOTIFY NOTNULL
          NULL NULLABLE NULLIF OBJECT OCTET_LENGTH OF OFF OFFSET OIDS
          OLD ON ONLY OPEN OPERATION OPERATOR OPTION OPTIONS OR ORDER
          ORDINALITY OUT OUTER OUTPUT OVERLAPS OVERLAY OVERRIDING
          OWNER PAD PARAMETER PARAMETERS PARAMETER_MODE PARAMATER_NAME
          PARAMATER_ORDINAL_POSITION PARAMETER_SPECIFIC_CATALOG
          PARAMETER_SPECIFIC_NAME PARAMATER_SPECIFIC_SCHEMA PARTIAL PASCAL
          PENDANT PLACING PLI POSITION POSTFIX PREFIX PREORDER
          PREPARE PRESERVE PRIMARY PRIOR PRIVILEGES PROCEDURAL PROCEDURE
          PUBLIC READ READS RECHECK RECURSIVE REF REFERENCES REFERENCING
          REINDEX RELATIVE RENAME REPEATABLE REPLACE RESET RESTART
          RESTRICT RESULT RETURN RETURNED_LENGTH RETURNED_OCTET_LENGTH
          RETURNED_SQLSTATE RETURNS REVOKE RIGHT ROLE ROLLBACK ROLLUP
          ROUTINE ROUTINE_CATALOG ROUTINE_NAME ROUTINE_SCHEMA ROW ROWS
          ROW_COUNT RULE SAVE_POINT SCALE SCHEMA SCHEMA_NAME SCOPE SCROLL
          SEARCH SECOND SECURITY SELECT SELF SENSITIVE SERIALIZABLE
          SERVER_NAME SESSION SESSION_USER SET SETOF SETS SHARE SHOW
          SIMILAR SIMPLE SIZE SOME SOURCE SPACE SPECIFIC SPECIFICTYPE
          SPECIFIC_NAME SQL SQLCODE SQLERROR SQLEXCEPTION SQLSTATE
          SQLWARNINIG STABLE START STATE STATEMENT STATIC STATISTICS
          STDIN STDOUT STORAGE STRICT STRUCTURE STYPE SUBCLASS_ORIGIN
          SUBLIST SUBSTRING SUM SYMMETRIC SYSID SYSTEM SYSTEM_USER
          TABLE TABLE_NAME  TEMP TEMPLATE TEMPORARY TERMINATE THAN THEN
          TIMEZONE_HOUR TIMEZONE_MINUTE TO TOAST TRAILING
          TRANSATION TRANSACTIONS_COMMITTED TRANSACTIONS_ROLLED_BACK
          TRANSATION_ACTIVE TRANSFORM TRANSFORMS TRANSLATE TRANSLATION
          TREAT TRIGGER TRIGGER_CATALOG TRIGGER_NAME TRIGGER_SCHEMA TRIM
          TRUE TRUNCATE TRUSTED TYPE UNCOMMITTED UNDER UNENCRYPTED UNION
          UNIQUE UNKNOWN UNLISTEN UNNAMED UNNEST UNTIL UPDATE UPPER
          USAGE USER USER_DEFINED_TYPE_CATALOG USER_DEFINED_TYPE_NAME
          USER_DEFINED_TYPE_SCHEMA USING VACUUM VALID VALIDATOR VALUES
          VARIABLE VERBOSE VERSION VIEW VOLATILE WHEN WHENEVER WHERE
          WITH WITHOUT WORK WRITE ZONE
        )
      end

      state :whitespace do
        rule %r/\s+/m, Text
        rule %r(//.*?$), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline
      end

      state :string do
        rule %r/%(\\.|.)+?%/, Str::Escape
        rule %r/\\"/, Str::Double
        rule %r/"/, Str::Double, :pop!
        rule %r/./m, Str::Double
      end

      state :string_s do
        rule %r/%(\\.|.)+?%/, Str::Escape
        rule %r/\\'/, Str::Single
        rule %r/'/, Str::Single, :pop!
        rule %r/./m, Str::Single
      end

      state :root do
        mixin :whitespace

        rule %r/^:#{id}/, Name::Label
        rule %r/@#{id}(\.#{id})?/m, Name::Entity
        rule %r/%(\\.|.)+?%/, Name::Variable
        rule %r/[~!%^&*()+=|\[\]{}:;,.<>\/?-]/, Punctuation
        rule %r/"/, Str::Double, :string
        rule %r/'/, Str::Single, :string_s
        rule %r/\d(\.\d*)?/i, Num
        rule %r/#{id}(?=\s*[(])/, Name::Function
        rule id do |m|
          name = m[0].upcase
          
          if self.class.sql_keywords.include? name
            token Keyword
          else
            token Name
          end
        end
      end

    end
  end
end

# frozen_string_literal: true

require 'active_record/connection_adapters/postgresql/schema_statements'

# Monkey-patch the refused Rails 4.2 patch at https://github.com/rails/rails/pull/31330
#
# Updates sequence logic to support PostgreSQL 10.
module SequencePatch
  # Resets the sequence of a table's primary key to the maximum value.
  def reset_pk_sequence!(table, pkey = nil, sequence = nil) #:nodoc:
    unless pkey && sequence
      default_pk, default_sequence = pk_and_sequence_for(table)

      pkey ||= default_pk
      sequence ||= default_sequence
    end

    @logger.warn "#{table} has primary key #{pkey} with no default sequence" if @logger && pkey && !sequence

    return unless pkey && sequence

    quoted_sequence = quote_table_name(sequence)
    max_pk = select_value("SELECT MAX(#{quote_column_name pkey}) FROM #{quote_table_name(table)}")
    if max_pk.nil?
      minvalue = if postgresql_version >= 100000
                   select_value("SELECT seqmin FROM pg_sequence WHERE seqrelid = #{quote(quoted_sequence)}::regclass")
                 else
                   select_value("SELECT min_value FROM #{quoted_sequence}")
                 end
    end

    select_value <<-SQL, 'SCHEMA'
              SELECT setval(#{quote(quoted_sequence)}, #{max_pk || minvalue}, #{max_pk ? true : false})
    SQL
  end
end

module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module SchemaStatements
        # Resets the sequence of a table's primary key to the maximum value.
        def reset_pk_sequence!(table, pkey = nil, sequence = nil) #:nodoc:
          unless pkey && sequence
            default_pk, default_sequence = pk_and_sequence_for(table)

            pkey ||= default_pk
            sequence ||= default_sequence
          end

          @logger.warn "#{table} has primary key #{pkey} with no default sequence" if @logger && pkey && !sequence

          return unless pkey && sequence

          quoted_sequence = quote_table_name(sequence)
          max_pk = select_value("SELECT MAX(#{quote_column_name pkey}) FROM #{quote_table_name(table)}")
          if max_pk.nil?
            minvalue = if postgresql_version >= 100000
                         select_value("SELECT seqmin FROM pg_sequence WHERE seqrelid = #{quote(quoted_sequence)}::regclass")
                       else
                         select_value("SELECT min_value FROM #{quoted_sequence}")
                       end
          end

          select_value <<-SQL, 'SCHEMA'
              SELECT setval(#{quote(quoted_sequence)}, #{max_pk || minvalue}, #{max_pk ? true : false})
          SQL
        end
      end
    end
  end
end

module ArJdbc
  module PostgreSQL
    # Resets the sequence of a table's primary key to the maximum value.
    def reset_pk_sequence!(table, pkey = nil, sequence = nil) #:nodoc:
      unless pkey && sequence
        default_pk, default_sequence = pk_and_sequence_for(table)

        pkey ||= default_pk
        sequence ||= default_sequence
      end

      @logger.warn "#{table} has primary key #{pkey} with no default sequence" if @logger && pkey && !sequence

      return unless pkey && sequence

      quoted_sequence = quote_table_name(sequence)
      max_pk = select_value("SELECT MAX(#{quote_column_name pkey}) FROM #{quote_table_name(table)}")
      if max_pk.nil?
        minvalue = if postgresql_version >= 100000
                     select_value("SELECT seqmin FROM pg_sequence WHERE seqrelid = #{quote(quoted_sequence)}::regclass")
                   else
                     select_value("SELECT min_value FROM #{quoted_sequence}")
                   end
      end

      select_value <<-SQL, 'SCHEMA'
              SELECT setval(#{quote(quoted_sequence)}, #{max_pk || minvalue}, #{max_pk ? true : false})
      SQL
    end
  end
end

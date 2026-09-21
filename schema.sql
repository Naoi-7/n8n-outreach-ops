-- Additions to company-enrich/schema.sql -- run that first. Nothing here
-- creates companies, contacts or outreach_log; it only adds the columns the
-- two workflows read and write, plus the offers table the sender reads.

-- ---------------------------------------------------------------- contacts

-- Pre-send signal: what the verifier said, checked BEFORE ever emailing.
ALTER TABLE contacts
  ADD COLUMN IF NOT EXISTS verification_status     text CHECK (verification_status IN ('valid', 'not valid')),
  ADD COLUMN IF NOT EXISTS verification_details    text,   -- the verifier's verdict in words (deliverable / catch-all / unconfirmed / invalid ...)
  ADD COLUMN IF NOT EXISTS verification_source     text,   -- which service
  ADD COLUMN IF NOT EXISTS verification_checked_at date;   -- the re-run guard: verify-contacts only ever picks rows where this is NULL

-- Post-send signal: the observed outcome AFTER a real send. An address can be
-- verification_status = 'valid' and still bounce -- the two answer different
-- questions and are kept apart on purpose.
ALTER TABLE contacts
  ADD COLUMN IF NOT EXISTS email_status        text CHECK (email_status IN ('sent', 'bounced', 'replied')),
  ADD COLUMN IF NOT EXISTS email_status_reason text;

-- ------------------------------------------------------------ outreach_log

-- One row per touch. company-enrich defines id, company_key, contact_email,
-- status and event_date; the sender fills the rest.
ALTER TABLE outreach_log
  ADD COLUMN IF NOT EXISTS campaign    text,     -- which list / campaign this send belongs to
  ADD COLUMN IF NOT EXISTS stage       text CHECK (stage IN ('intro', 'followup', 'reply')),
  ADD COLUMN IF NOT EXISTS sent        boolean,
  ADD COLUMN IF NOT EXISTS notes       text,     -- 'offer:<offer_id>' -- the re-send guard: a company that has this note in this campaign is never sent the same offer again
  ADD COLUMN IF NOT EXISTS who         text,     -- which sending mailbox: 'A' or 'B'
  ADD COLUMN IF NOT EXISTS products    text,     -- what the offer covered, free text
  ADD COLUMN IF NOT EXISTS kind        text NOT NULL DEFAULT 'email' CHECK (kind IN ('email', 'call', 'meeting', 'note')),
  ADD COLUMN IF NOT EXISTS source      text CHECK (source IN ('crm', 'n8n', 'migration')),
  ADD COLUMN IF NOT EXISTS external_id text,     -- the mail provider's message id, so a retry cannot log the same send twice
  ADD COLUMN IF NOT EXISTS body        text;     -- the full email as sent

CREATE UNIQUE INDEX IF NOT EXISTS outreach_log_external_id ON outreach_log (external_id) WHERE external_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS outreach_log_company_campaign ON outreach_log (company_key, campaign);

-- ------------------------------------------------------------------ offers

-- The text of each offer, keyed by the id Run settings names. The sender
-- reads every row and picks one; the id also becomes the outreach_log note
-- that stops a repeat. See offers.example.sql for the shape.
CREATE TABLE IF NOT EXISTS offers (
  offer_id   text PRIMARY KEY,
  offer      text NOT NULL,        -- HTML (a table, or a block in white-space: pre-wrap); newlines become <br>
  created_at timestamptz NOT NULL DEFAULT now()
);
